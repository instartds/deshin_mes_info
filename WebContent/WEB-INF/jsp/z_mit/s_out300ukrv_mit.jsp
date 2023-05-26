<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_out300ukrv_mit"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_out300ukrv_mit"/>
	<t:ExtComboStore items="${WORKER_CODE}" storeId="workerCode" /> <!-- 작업자코드 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var closeStore = Ext.create('Ext.data.Store', {
    id : 'closeStore',
	fields : ['text', 'value'],
    data   : [
        {text : '마감'  , value: 'Y'},
        {text : '미마감' , value: 'N'}
    ]
});
function appMain() {  
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_out300ukrv_mitService.selectList',
			update: 's_out300ukrv_mitService.updateList',
			destroy: 's_out300ukrv_mitService.deleteList',
			syncAll: 's_out300ukrv_mitService.saveAll'
		}
	});	
	
	Unilite.defineModel('s_out300ukrv_mitModel', {
	    fields: [  	
	    	  {name : 'DIV_CODE'            , text : '사업장코드'   	, type : 'string'       , allowBlank : false, comboType:"BOR120" , editable : false}
	    	, {name : 'PAY_YYYYMM'          , text : '기준월'      	, type : 'string'       , allowBlank : false, editable : false}
    	    , {name : 'WORKER_CODE'    		, text : '작업자코드'  	, type : 'string'     	, allowBlank : false, editable : false }
	    	, {name : 'WORKER_NAME'         , text : '작업자명	'       , type : 'string'		, editable : false}
	    	, {name : 'JOIN_DATE'           , text : '입사일	'     	, type : 'uniDate'	, editable : false}
	    	, {name : 'WORKING_YEARS'       , text : '근속년수	'     	, type : 'int'	, editable : false}
	    	, {name : 'GOOD_WORK_Q'         , text : '실적수량	'     	, type : 'uniQty'	, editable : false}
	    	, {name : 'BAD_WORK_Q'          , text : '부적합수량'    	, type : 'uniQty'	, editable : false}
	    	, {name : 'PRODT_AMT'           , text : '엮기비용	'     	, type : 'uniPrice'}
	    	, {name : 'CONTI_AMT'           , text : '근속수당'     	, type : 'uniPrice'}
	    	, {name : 'EDU_AMT'             , text : '교육비'     	, type : 'uniPrice'}
	    	, {name : 'BIRTH_AMT'           , text : '생일축하금'   	, type : 'uniPrice'}
	    	, {name : 'TETANUS_MAT'         , text : '파상품지원금'  	, type : 'uniPrice'}
	    	, {name : 'RETRO_AMT'           , text : '소급비용'      	, type : 'uniPrice'}
	    	, {name : 'RETRO_REMARK'        , text : '소급내역'      	, type : 'string'}
	    	, {name : 'REWARD_AMT'          , text : '보상비용'     	, type : 'uniPrice'}
	    	, {name : 'TOT_AMT'             , text : '총계'       	, type : 'uniPrice'		, editable :false}
	    	, {name : 'REMARK'              , text : '비고'       	, type : 'string'}
	    	, {name : 'CLOSE_YN'            , text : '마감여부'     	, type : 'string'      , store : Ext.data.StoreManager.lookup("closeStore"), editable : false}
	    	, {name : 'FLAG'                , text : '신규여부'     	, type : 'string'}
	    ]
	});
	function getMonthFormat(v)	{
		return Ext.isDate(v) ? Ext.Date.format(v,'Y.m') : v;
	}
	var directMasterStore = Unilite.createStore('s_out300ukrv_mitMasterStore',{
		model: 's_out300ukrv_mitModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
            allDeletable: false,
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
      
        	if(panelResult.getInvalidMessage())	{
				var param= Ext.getCmp('resultForm').getValues();		
				panelResult.setDisablekeys(true);
				this.load({
					params : param,
					callback: function(records, operation, success) {
						if(success){
							Ext.each(records, function(record, idx)	{
								if(record.get("FLAG") == "S")	{
									record.set("FLAG", "신규");
								}
								if(idx == 0)	{//btnS_out300ukrv_mitClose btnS_out300ukrv_mitCancel
									if(record.get("CLOSE_YN")=="Y")	{
										panelResult.down("#btnS_out300ukrv_mitClose").hide();
										panelResult.down("#btnS_out300ukrv_mitCancel").show();
									} else {

										panelResult.down("#btnS_out300ukrv_mitCancel").hide();
										panelResult.down("#btnS_out300ukrv_mitClose").show();
									}
								}
							});
						}
					}
				});
        	}
		},
		saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				var config = {}
				var checkDataList = this.getData().items;
				var check = true;
				Ext.each(checkDataList, function(checkData, idx) {
					if(checkData.get("CLOSE_YN") == "Y")	{
						check = false;
					}
				} );
				if(checkDataList.length > 0 && !check)	{
					Unilite.messageBox("마감 되어 수정할 수 없습니다.");
					return;
				}
				this.syncAllDirect({
					params: [panelResult.getValues()],
					success:function()	{
						//UniAppManager.app.onQueryButtonDown()
					}
				});
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 6},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '사업장'  ,
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value       :  UserInfo.divCode,
			allowBlank	: false
		},{
			fieldLabel		: '급여월',
			xtype			: 'uniMonthfield',
			name	        : 'PAY_YYYYMM',
			value			: UniDate.get('today'),
			allowBlank	    : false
		},{
			fieldLabel		: '작업자',
			xtype			: 'uniCombobox',
			name	        : 'WORKER_CODE',
			store           : Ext.data.StoreManager.lookup('workerCode') 
		},{
			xtype			: 'button',
			text	        : '마감',
			itemId          : 'btnS_out300ukrv_mitClose',
			width           : 100,
			tdAttrs         : {width :120, align : 'center'},
			handler         : function() {
				if(UniAppManager.app._needSave())	{
					if(confirm("저장할 내용이 있습니다. 저장하시겠습니까?"))	{
						UniAppManager.app.onSaveDataButtonDown();
					}
					return;
				}
				if(!panelResult.getInvalidMessage())	{
					return;
				}
				var param = panelResult.getValues();
				param.CLOSE_YN = "Y";
				s_out300ukrv_mitService.updatClose(param, function(responseText){
					 if(responseText)	{
						 UniAppManager.updateStatus("마감처리 되었습니다.")
						 UniAppManager.app.onQueryButtonDown();
					 }
				 })
				
			}
		},{
			
			xtype			: 'button',
			text	        : '마감취소',
			itemId          : 'btnS_out300ukrv_mitCancel', 
			width           : 100,
			hidden          : true,
			tdAttrs         : {width :120, align : 'center'},
			handler         : function() {
				var selRecord = masterGrid.getSelectedRecords();
				if(UniAppManager.app._needSave())	{
					if(confirm("저장할 내용이 있습니다. 저장하시겠습니까?"))	{
						UniAppManager.app.onSaveDataButtonDown();
					}
					return;
				}
				if(!panelResult.getInvalidMessage())	{
					return;
				}
				var param = panelResult.getValues();
				param.CLOSE_YN = "N";
				s_out300ukrv_mitService.updatClose(param, function(responseText){
					 if(responseText)	{
						 UniAppManager.updateStatus("마감 취소 되었습니다.")
						 UniAppManager.app.onQueryButtonDown();
					 }
				 })
			}
		},{
			
			xtype			: 'button',
			text	        : '명세서출력',
			width           : 100,
			tdAttrs         : {width :120, align : 'center'},
			handler         : function() {
//				alert(new Date('2020-01-01'));
//				return;
				
				var param = panelResult.getValues();
				
				if(!panelResult.getInvalidMessage())	{
					return;
				}
				var win;
				var records = masterGrid.getSelectedRecords();
				if(Ext.isEmpty(records))	{
					Unilite.messageBox("명세서를 출력할 작업자를 선택하세요.");
					return;
				}
				var workers = new Array();
				Ext.each(records, function(record){
					workers.push(record.get("WORKER_CODE"));
				} );
				param.WORKERS = workers.join(',');
				param.sTxtValue2_fileTitle = '외주용역비 내역';
				
				win = Ext.create('widget.ClipReport', {
					url		: CPATH + '/z_mit/s_out300clrkrv_mit.do',
					prgID	: 's_out300ukrv_mit',
					extParam: param
				});
				win.center();
				win.show();
			}
		}],
		setDisablekeys: function(disable) {
			var me = this;
			me.getField("DIV_CODE").setReadOnly(disable);
			me.getField("PAY_YYYYMM").setReadOnly(disable);
		}
	});	
	
    var masterGrid = Unilite.createGrid('s_out300ukrv_mitGrid', {
        store: directMasterStore,
    	region: 'center',
    	flex:1,
    	uniOpt :{
    		onLoadSelectFirst: false
    	},
    	selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : true }),
        columns:  [     
        	    {dataIndex : 'DIV_CODE'      , width : 80	,hidden : true}
        	  , {dataIndex : 'PAY_YYYYMM'    , width : 80    ,hidden : true}
        	  , {dataIndex : 'CLOSE_YN'      , width : 80}
        	  , {dataIndex : 'WORKER_NAME'   , width : 100}
        	  , {dataIndex : 'WORKER_CODE'   , width : 100}
        	  , {dataIndex : 'JOIN_DATE'     , width : 80}
  	    	  , {dataIndex : 'WORKING_YEARS' , width : 80}
  	    	  , {dataIndex : 'GOOD_WORK_Q'   , width : 80}
  	    	  , {dataIndex : 'BAD_WORK_Q'    , width : 110}
        	  , {dataIndex : 'PRODT_AMT'     , width : 80}
        	  , {dataIndex : 'CONTI_AMT'     , width : 80}
        	  , {dataIndex : 'EDU_AMT'       , width : 80}
        	  , {dataIndex : 'BIRTH_AMT'     , width : 100}
        	  , {dataIndex : 'TETANUS_MAT'   , width : 110}
        	  , {dataIndex : 'RETRO_AMT'     , width : 80}
        	  , {dataIndex : 'RETRO_REMARK'  , width : 150}
        	  , {dataIndex : 'REWARD_AMT'    , width : 80}
        	  , {dataIndex : 'TOT_AMT'       , width : 80}
        	  , {dataIndex : 'REMARK'        , width : 150}
        	  , {dataIndex : 'FLAG'          , width : 50}
		],
		listeners:{
			/* beforeedit: function( editor, e, eOpts ) {
				if(e.field == 'REMARK'  ){
					return true;
				} else {
					return false;
				}
			}  */
		}
    });  
    
    
	Unilite.Main( {
		borderItems:[
			panelResult,masterGrid
		],
		id: 's_out300ukrv_mitApp',
		fnInitBinding : function() {
			panelResult.setValue("DIV_CODE", UserInfo.divCode);
			panelResult.setValue("PAY_YYYYMM", UniDate.get('today'));
			
			panelResult.setDisablekeys(false);
			
			UniAppManager.setToolbarButtons(['reset'],true);
			UniAppManager.setToolbarButtons(['save','newData'],false);
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {		
			masterGrid.reset();
			panelResult.clearForm();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		sumAmt : function(record, editFieldName, newValue) {
			//(T3.PRODT_AMT + T3.CONTI_AMT + T3.EDU_AMT + T3.BIRTH_AMT + T3.TETANUS_MAT + T3.RETRO_AMT + T3.REWARD_AMT)
			var tot_amt = record.get("PRODT_AMT") +  record.get("CONTI_AMT") +  record.get("EDU_AMT") +  record.get("BIRTH_AMT") +  record.get("TETANUS_MAT") +  record.get("RETRO_AMT") +  record.get("REWARD_AMT") ;
			tot_amt = tot_amt - record.get(editFieldName) + newValue
			
			record.set("TOT_AMT", tot_amt)
		}
	});	
	
	Unilite.createValidator('validator01', {		//그리드 벨리데이터 관련		
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':''},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(newValue == oldValue)	{
				return;
			}
			
			switch(fieldName){
				case "PRODT_AMT" : 
					UniAppManager.app.sumAmt (record.obj, fieldName, newValue);
					break;
				case "CONTI_AMT" : 
					UniAppManager.app.sumAmt (record.obj, fieldName, newValue);
					break;
				case "EDU_AMT" : 
					UniAppManager.app.sumAmt (record.obj, fieldName, newValue);
					break;
				case "BIRTH_AMT" : 
					UniAppManager.app.sumAmt (record.obj, fieldName, newValue);
					break;
				case "TETANUS_MAT" : 
					UniAppManager.app.sumAmt (record.obj, fieldName, newValue);
					break;
				case "RETRO_AMT" : 
					UniAppManager.app.sumAmt (record.obj, fieldName, newValue);
					break;
				case "REWARD_AMT" : 
					UniAppManager.app.sumAmt (record.obj, fieldName, newValue);
					break;
				default:
				 	break;
			}
			return rv;
		}
	});
};


</script>
