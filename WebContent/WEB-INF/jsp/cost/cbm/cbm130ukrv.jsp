<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cbm130ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="CC02" /><!--직간접구분-->
	<t:ExtComboStore comboType="AU" comboCode="C007" /><!--경비/노무비구분-->
	<t:ExtComboStore comboType="AU" comboCode="CA02" /><!--집계유형-->
	<t:ExtComboStore comboType="AU" comboCode="CA03" /><!-사용자정의배부유형-->
	<t:ExtComboStore comboType="AU" comboCode="CA04" /><!--배부유형-->
	<t:ExtComboStore comboType="AU" comboCode="CA05" /><!--사용자정의배부유형 -->
	
</t:appConfig>	
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {     
	var costAccntCode1 = '${costAccntCode1}' //원재료비
	/* 월별 배부기준 등록 */
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cbm130ukrvService.selectList1',
        	create  : 'cbm130ukrvService.insertDetail1',
            update  : 'cbm130ukrvService.updateDetail1',
            destroy  : 'cbm130ukrvService.deleteDetail1',
            syncAll : 'cbm130ukrvService.saveAll1'
		}
	 });
	 
	/* Model 정의 
	 * @type 
	 */	
	/* 월별 배부기준 등록 */
	//모델 정의
	Unilite.defineModel('cbm130ukrvModel1', {
	    fields: [
 			{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string', editable:false},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'			, type: 'string', editable:false},
			{name: 'WORK_MONTH'			, text: 'WORK_MONTH'		, type: 'string', editable:false},
			{name: 'ACCNT'				, text: '계정코드'			, type: 'string', editable:false},
			{name: 'ACCNT_NAME'			, text: '계정명'				, type: 'string', editable:false},
    		{name: 'SUMMARY_CODE'		, text: '집계유형'			, type: 'string', comboType:'AU', comboCode:'CA02'},
			{name: 'SUM_DEFINE_CODE'	, text: '사용자정의배부유형'	, type: 'string', comboType:'AU', comboCode:'CA03'},
			{name: 'ALLOCATION_CODE'	, text: '배부유형'			, type: 'string', comboType:'AU', comboCode:'CA04'},
			{name: 'ALL_DEFINE_CODE'	, text: '사용자정의배부유형'	, type: 'string', comboType:'AU', comboCode:'CA05'},
			{name: 'ID_GB'				, text: '직간접구분'			, type: 'string', comboType:'AU', comboCode:'CC02', editable:true},
			{name: 'COST_GB'			, text: '비목구분'		, type: 'string', comboType:'AU', comboCode:'C007', editable:false},
			{name: 'UPDATE_DB_TIME'		, text: '신규생성 체크 '		, type: 'string'}
			
		]
	});	

	//스토어 정의
	var cbm130ukrvStore1 = Unilite.createStore('cbm130ukrvStore1',{
		model: 'cbm130ukrvModel1',
        autoLoad: false,
        uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxy1,
        loadStoreRecords : function()	{
			this.load({
				 params:panelResult.getValues()
			});
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
		layout:{type:'uniTable', columns:'3'},
		items:[{
			xtype:'uniCombobox',
			comboType:'BOR120',
			fieldLabel:'사업장',
			name:'DIV_CODE',
			value:UserInfo.divCode
		},{
			xtype:'uniMonthfield',
			fieldLabel:'기준년월',
			labelWidth:120,
			name:'WORK_MONTH',
			value:UniDate.get('today')
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
				var param = form.getValues();
				param.PREV_MONTH = UniDate.getMonthStr(UniDate.add(form.getValue('WORK_MONTH'), {'months':-1}));
				Ext.getBody().mask("Loading...");
				cbm130ukrvService.selectCopy1(param, function(responseText, response){
					masterGrid.reset();
					cbm130ukrvStore1.loadData(responseText);
					cbm130ukrvStore1.setCheckRecord(cbm130ukrvStore1.getData().items);
					form.setValue('isCopy', 'Y');
					Ext.getBody().unmask()
				});
			}
		},
		Unilite.popup('ACCNT',{}),{
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'C007',
			fieldLabel:'비목구분',
			labelWidth:120,
			name:'COST_GB'
		}]
	
	});
	
	var masterGrid = Unilite.createGrid('cbm130ukrvGrid', {	
		region:'center',
		xtype: 'uniGridPanel',
		itemId:'calcuBasisGrid1',
	    store : cbm130ukrvStore1,
	    uniOpt: {			
		    useMultipleSorting	: true,		
		    useLiveSearch		: true,		
		    onLoadSelectFirst	: true,			
		    dblClickToEdit		: true,		
		    useGroupSummary		: false,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: false,	
			copiedRow			: false,
		    filter: {				
				useFilter		: false,
				autoCreate		: false
			}			
		},		        
		columns: [
 			{dataIndex: 'COMP_CODE'			, width: 100,		hidden: true},
			{dataIndex: 'DIV_CODE'			, width: 100,		hidden: true},
			{dataIndex: 'WORK_MONTH'		, width: 100,		hidden: true},
			
			{dataIndex: 'ACCNT'				, width: 80},
			{dataIndex: 'ACCNT_NAME'		, width: 130},
			{text:'원가정보',
	    	 columns:[
	    	 	{dataIndex: 'ID_GB'				, width: 100},
				{dataIndex: 'COST_GB'			, width: 110}
			 ]
			},
	    	{text:'비목을 부문별로 집계시 기준정보',
	    	 columns:[
	    		{dataIndex: 'SUMMARY_CODE'		, width: 400, editor:{
	    			xtype:'uniCombobox',
	    			comboType:'AU',
	    			comboCode:'CA02',
	    			listeners:{
						beforequery:function(queryPlan){
							var store = queryPlan.combo.store;
							var dataStore = Ext.StoreManager.lookup('CBS_AU_CA02');	
							if(costAccntCode1 != '' && masterGrid.uniOpt.currentRecord.get('ACCNT') == costAccntCode1)	{
								
								var data = Ext.Array.push(dataStore.data.filterBy(function(record) {
				  						var summaryCodeArr =['11','12','51'];
				  						return (UniUtils.indexOf( record.get('value') , summaryCodeArr ) )
				  					} ).items);
								store.loadData(data);
							} else {
				  				var data = dataStore.getData().items;
								store.loadData(data);
							}
						}
	    			}
				}},
				{dataIndex: 'SUM_DEFINE_CODE'		, width: 150}
			 ]
			}/* cbm140ukrv 개발 후 필요없어짐, 사이트 별 가변성을 고려해 DB table의 field는 유지할 예정
			,
			{text:'보조부문을 제조부문으로 배부시 기준정보',
	    	 columns:[
	    	 	{dataIndex: 'ALLOCATION_CODE'		, width: 400},
				{dataIndex: 'ALL_DEFINE_CODE'		, width: 150}
			 ]
			}*/
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(e.field == 'SUM_DEFINE_CODE' && e.record.get("SUMMARY_CODE") !='51'){
					return false;
				}
				if(e.field == 'ALL_DEFINE_CODE' && e.record.get("ALLOCATION_CODE") !='51'){
					return false;
				}
				if(e.field == 'ID_GB' && e.record.get("ACCNT") == costAccntCode1){
					return false;
				}
			}
		}
	});

	Unilite.Main( {
		id 			: 'cbm130ukrvApp',
		borderItems : [ 
			panelResult, masterGrid		 	
		], 
		fnInitBinding : function(param) {			
			if(param && param.DIV_CODE)	{
				panelResult.setValue("DIV_CODE",param.DIV_CODE);
				panelResult.setValue("WORK_MONTH",param.WORK_MONTH);
			}
			UniAppManager.setToolbarButtons(['reset','newData','delete'],false);
			UniAppManager.setToolbarButtons(['query','excel'],true);
			cbm130ukrvStore1.loadStoreRecords();
		},
		onQueryButtonDown : function()	{		
			UniAppManager.setToolbarButtons(['reset','newData','delete'],false);
			UniAppManager.setToolbarButtons(['query','excel'],true);
			cbm130ukrvStore1.loadStoreRecords();
		},
		onNewDataButtonDown : function()	{

				var sortSeq			= 1;
				var r = {
					SORT_SEQ		: sortSeq
				}
				masterGrid.createRow(r);
			

		},
		onSaveDataButtonDown: function () {
			cbm130ukrvStore1.saveStore();
		}
	});
	
	Unilite.createValidator('validator01', {
		store : cbm130ukrvStore1,
		grid:  masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, ePanel, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var sAccnt = record.get("ACCNT");
			
			if(fieldName=='SUMMARY_CODE')	{
				if(newValue != '')	{
					if( newValue != "51" ) {					
						record.set("SUM_DEFINE_CODE", "");			//SUMMARY_CODE가 51인 경우만 입력
					}
					if(newValue == "06") {
						record.set("ID_GB", "1");
					} else {
						record.set("ID_GB", "2");
					}
				}
			} else if( fieldName == 'ALLOCATION_CODE' ) {
				if(newValue != '')	{
					if( newValue != "51" ) {					
						record.set("ALL_DEFINE_CODE", "");			//ALLOCATION_CODE가 51인 경우만 입력
					}
				}
			}
			return rv;
		}
	});
};

</script>
