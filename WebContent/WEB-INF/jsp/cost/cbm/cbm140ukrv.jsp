<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cbm140ukrv"  >
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
	var allocationCostList = ${ALLOCATION_COST_POOL};
	var defaultAllocationCode = "${DEFAULT_ALLOCATION_CODE}";
	
	/* 월별 배부기준 등록 */
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cbm140ukrvService.selectList1',
        	create  : 'cbm140ukrvService.insertDetail1',
            update  : 'cbm140ukrvService.updateDetail1',
            destroy  : 'cbm140ukrvService.deleteDetail1',
            syncAll : 'cbm140ukrvService.saveAll1'
		}
	 });
	 
	/* Model 정의 
	 * @type 
	 */	
	/* 월별 배부기준 등록 */
	//모델 정의
	 var cbm140ModelFields = [
   		{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string', editable:false},
		{name: 'DIV_CODE'			, text: 'DIV_CODE'			, type: 'string', editable:false},
		{name: 'WORK_MONTH'			, text: 'WORK_MONTH'		, type: 'string', editable:false},
		{name: 'COST_POOL_CODE'		, text: '보조부문코드'		, type: 'string', editable:false},
		{name: 'COST_POOL_NAME'		, text: '보조부문'			, type: 'string', editable:false},
		{name: 'ALLOCATION_CODE'	, text: '배부유형'			, type: 'string', comboType:'AU', comboCode:'CA04', allowBlank:false, defaultValue:defaultAllocationCode},
		{name: 'UPDATE_DB_TIME'		, text: '신규생성 체크 '	, type: 'string'}
    ];
    
	Ext.each(allocationCostList, function(item){
    	cbm140ModelFields.push({name: "ALLOCATION_COST_POOL_"+item.COST_POOL_CODE	, text: item.COST_POOL_NAME+" 배부값"	, type: 'uniPrice'});
    })
    
    var cbm140ukrvModel1 = Unilite.defineModel('cbm140ukrvModel1', {
		fields: cbm140ModelFields
   	});
	//스토어 정의
	var cbm140ukrvStore1 = Unilite.createStore('cbm140ukrvStore1',{
		model: 'cbm140ukrvModel1',
        autoLoad: false,
        uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxy1,
        loadStoreRecords : function()	{
        	if(!allocationCostList || allocationCostList.length == 0)	{
        		alert("등록된 부문이 없습니다.")
        		return;
        	} else {
        		var checkCnt = 0
        		Ext.each(allocationCostList , function(item){
        			if(item.DIV_CODE == panelResult.getValue("DIV_CODE"))	{
        				checkCnt = 1;
        			}
        		})
        		if(checkCnt == 0)	{
        			alert("해당 사업장에 등록된 부문이 없습니다.")
        			return;
        		}
        	}
        	
			masterGrid.loadCostPoolColumns(panelResult.getValue("DIV_CODE"));
			this.load({
				 params:panelResult.getValues()
			});
		},
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
		
			var rv = true;
						    
			if(inValidRecs.length == 0 ) {        
				var records = this.getData();
				var chk = true;
				Ext.each(records.items, function(record, idx){
					if(record.get("ALLOCATION_CODE") == "51")	{
						var sum = 0;
						Ext.each(allocationCostList, function(item){
					    	sum += record.get("ALLOCATION_COST_POOL_"+item.COST_POOL_CODE);
					    })
					    if(sum <= 0)	{
					    	chk = false;
					    }
					}
				});
				if(!chk) {
					alert("배부값을 입력하세요.")
					return;
				}
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
			value:UserInfo.divCode,
			allowBlank:false,
			listeners:{
				change:function(field, newValue, oldValue)	{
					masterGrid.loadCostPoolColumns(newValue);
					cbm140ukrvStore1.loadStoreRecords();
				}
			}
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
//				var form  = panelResult;
//				var param = form.getValues();
//				param.PREV_MONTH = UniDate.getMonthStr(UniDate.add(form.getValue('WORK_MONTH'), {'months':-1}));
//				Ext.getBody().mask("Loading...");
//				cbm140ukrvService.selectCopy1(param, function(responseText, response){
//					masterGrid.reset();
//					cbm140ukrvStore1.loadData(responseText);
//					cbm140ukrvStore1.setCheckRecord(cbm140ukrvStore1.getData().items);
//					form.setValue('isCopy', 'Y');
//					Ext.getBody().unmask()
//				});
				
				masterGrid.reset();
				var param = panelResult.getValues();
				cbm140ukrvService.fnCopyPrevMonth(param, function(responseText, response){
					if(!Ext.isEmpty(response) && response.result.ERROR_DESC == 'success') {
						cbm140ukrvStore1.loadStoreRecords();
					}
				});
			}
		}]
	
	});
	
	var excelImportColumns = [];
	
	var masterGridColumns = [
		{dataIndex: 'DIV_CODE'			, width: 100,		hidden: true},
			{dataIndex: 'WORK_MONTH'		, width: 100,		hidden: true},
			{dataIndex: 'COST_POOL_CODE'		, width: 80,		hidden: true},
			{dataIndex: 'COST_POOL_NAME'		, width: 130},
	    	{dataIndex: 'ALLOCATION_CODE'		, width: 400}
	] 
	Ext.each(allocationCostList, function(item){
    	masterGridColumns.push({dataIndex: "ALLOCATION_COST_POOL_"+item.COST_POOL_CODE	, width: 130});
    	excelImportColumns.push("ALLOCATION_COST_POOL_"+item.COST_POOL_CODE);
    })
	var masterGrid = Unilite.createGrid('cbm140ukrvGrid', {	
		region:'center',
		xtype: 'uniGridPanel',
		itemId:'calcuBasisGrid1',
	    store : cbm140ukrvStore1,
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
			
			importData :{	// 엑셀에서 복사한 내용 붙여넣기 설정	
				useData :true, 
				configId: "",
				createOption: "customFn",
				columns : excelImportColumns
			},
			
		    filter: {				
				useFilter		: false,
				autoCreate		: false
			}			
		},		        
		columns: masterGridColumns,
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(e.field.indexOf('ALLOCATION_COST_POOL_') == 0 && e.record.get("ALLOCATION_CODE") !='51'){
					return false;
				}
			},
			render:function(grid)	{
				var me = grid;
				me.loadCostPoolColumns(UserInfo.divCode);
			}
		},
		loadCostPoolColumns:function(divCode)	{
			var me = this;
			
			Ext.each(allocationCostList, function(item){
				if(item.DIV_CODE == divCode )	{
					me.getColumn("ALLOCATION_COST_POOL_"+item.COST_POOL_CODE).show();
				} else {
					me.getColumn("ALLOCATION_COST_POOL_"+item.COST_POOL_CODE).hide();
				}
		    })
			
		}
		,
		//엑셀 붙여넣기
		loadImportData:function(dataList) {
			var me = this;
			//var cnrcYear = panelResult.getValue('CNRC_YEAR');
			//var meritsYear = panelResult.getValue('MERITS_YEARS');
			var itemArray = [];
			
			var masterRecords = cbm140ukrvStore1.data.items;
			
			var lLoop = 0;
			
			if(dataList.length > 0) {
				for(var iLoop in dataList) {
					if(masterRecords.length > iLoop) {
						var data = dataList[iLoop];
						var record = masterRecords[iLoop];
						
						Ext.each(excelImportColumns, function(column) {
							record.set(column, data[column]);
						});
					}
				}
			}		
			
		}
	});

	Unilite.Main( {
		id 			: 'cbm140ukrvApp',
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
			cbm140ukrvStore1.loadStoreRecords();
		},
		onQueryButtonDown : function()	{		
			UniAppManager.setToolbarButtons(['reset','newData','delete'],false);
			UniAppManager.setToolbarButtons(['query','excel'],true);
			cbm140ukrvStore1.loadStoreRecords();
		},
		onNewDataButtonDown : function()	{

				var sortSeq			= 1;
				var r = {
					SORT_SEQ		: sortSeq
				}
				masterGrid.createRow(r);
			

		},
		onSaveDataButtonDown: function () {
			cbm140ukrvStore1.saveStore();
		}
	});
	
	Unilite.createValidator('validator01', {
		store : cbm140ukrvStore1,
		grid:  masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, ePanel, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var sAccnt = record.get("ACCNT");
			
			if( fieldName == 'ALLOCATION_CODE' ) {
				if(newValue != '')	{
					if( newValue != "51" ) {		
						Ext.each(allocationCostList, function(item){
					    	record.set("ALLOCATION_COST_POOL_"+item.COST_POOL_CODE	, 0);
					    })
					}
				}
			}
			return rv;
		}
	});
};

</script>
