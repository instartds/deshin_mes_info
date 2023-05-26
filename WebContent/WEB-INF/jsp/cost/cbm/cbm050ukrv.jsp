<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="cbm050ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="B010" />	<!-- 예/아니오 -->
	<t:ExtComboStore comboType="AU" comboCode="CD20" /> <!-- 제조/판관 -->
	<t:ExtComboStore comboType="AU" comboCode="CD21" /> <!-- CostPool구분(직접/간접) -->
	<t:ExtComboStore comboType="AU" comboCode="CD27" /> <!-- 공통CostPool구분(전체공통/직과공통) -->
	<t:ExtComboStore comboType="AU" comboCode="CD22" /> <!-- 공통CostPool배부유형 -->
	<t:ExtComboStore comboType="AU" comboCode="CC02" /><!--직간접구분-->
	<t:ExtComboStore comboType="AU" comboCode="C007" /><!--경비/노무비구분-->
	<t:ExtComboStore comboType="AU" comboCode="CD15" /><!--경비구분-->
	<t:ExtComboStore comboType="AU" comboCode="CD16" /><!-집계유형-->
	<t:ExtComboStore comboType="AU" comboCode="CD17" /><!--집계금액기준-->
	<t:ExtComboStore comboType="AU" comboCode="CD18" /><!--배부유형(CP적용) -->
	<t:ExtComboStore comboType="AU" comboCode="CD19" /><!--배부참조기준 -->
	<t:ExtComboStore comboType="AU" comboCode="M104" /><!--수불유형 -->
	<t:ExtComboStore items="${MANAGE_CODE_COMBO}" storeId="manageCodeCombo" />	
	
</t:appConfig>	
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {     

	/* 월별 배부기준 등록 */
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		   	read    : 'cbm050ukrvService.selectList1',
        	create  : 'cbm050ukrvService.insertDetail1',
            update  : 'cbm050ukrvService.updateDetail1',
            destroy  : 'cbm050ukrvService.deleteDetail1',
            syncAll : 'cbm050ukrvService.saveAll1'
		}
	 });
	 
	/* 품목별 배부율 등록 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read    : 'cbm020ukrvService.selectList2',
			create  : 'cbm020ukrvService.insertDetail2',
			update  : 'cbm020ukrvService.updateDetail2',
			destroy : 'cbm020ukrvService.deleteDetail2',
			syncAll : 'cbm020ukrvService.saveAll2'
		}
 	});
	 
	/* Model 정의 
	 * @type 
	 */	
	/* 월별 배부기준 등록 */
	//모델 정의
	Unilite.defineModel('cbm050ukrvModel1', {
	    fields: [
 			{name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string', editable:false},
			{name: 'DIV_CODE'			, text: 'DIV_CODE'		, type: 'string', editable:false},
			{name: 'WORK_MONTH'			, text: 'WORK_MONTH'	, type: 'string', editable:false},
			{name: 'AC_DIVI'			, text: '경비구분'			, type: 'string', comboType:'AU', comboCode:'CD15', editable:false},
			{name: 'ACCNT'				, text: '계정코드'			, type: 'string', editable:false},
			{name: 'ACCNT_NAME'			, text: '계정명'			, type: 'string', editable:false},
    		{name: 'COST_CENTER_CODE'	, text:'Cost Center'		, type: 'string', allowBlank:false, editable:false},
    		{name: 'COST_CENTER_NAME'	, text:'Cost Center명'		, type: 'string', allowBlank:false, editable:false},
			{name: 'SUM_STND_CD'		, text: '집계정보'			, type: 'string', comboType:'AU', comboCode:'CD16'},
			{name: 'AMT_STND_CD'		, text: '금액기준'			, type: 'string', comboType:'AU', comboCode:'CD17'},
			{name: 'MANAGE_CODE1'		, text: '집계관리항목1'		, type: 'string', store:Ext.data.StoreManager.lookup('manageCodeCombo')},
			{name: 'MANAGE_CODE2'		, text: '집계관리항목2'		, type: 'string', store:Ext.data.StoreManager.lookup('manageCodeCombo')},
			{name: 'INOUT_TYPE_DETAIL'	, text: '수불유형'			, type: 'string', comboType:'AU', comboCode:'M104'},
			{name: 'DISTR_STND_CD'		, text: '배부유형'			, type: 'string', comboType:'AU', comboCode:'CD18'},
			{name: 'CP_DIRECT_YN'		, text: '직과여부'			, type: 'string', comboType:'AU', comboCode:'B010'},
			{name: 'DISTR_REFER_CD'		, text: '배부기준'			, type: 'string', comboType:'AU', comboCode:'CD19'},
			{name: 'ID_GB'				, text: '직간접구분'		, type: 'string', comboType:'AU', comboCode:'CC02'},
			{name: 'COST_GB'			, text: '노무비/경비구분'	, type: 'string', comboType:'AU', comboCode:'C007'},
			{name: 'UPDATE_DB_TIME'		, text: '신규생성 체크 '	, type: 'string'}
			
		]
	});	

	//스토어 정의
	var cbm050ukrvStore1 = Unilite.createStore('cbm050ukrvStore1',{
		model: 'cbm050ukrvModel1',
        autoLoad: false,
        uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxy1,
        loadStoreRecords : function()	{
        	var param = Ext.getCmp('tab_calcuBasis').down('#calcuBasisSearch1');
			this.load({
				 params:param.getValues()
			});
		},
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
		
			var rv = true;
		    var form  = Ext.getCmp('tab_calcuBasis').down('#calcuBasisSearch1');
						    
			if(inValidRecs.length == 0 ) {          
				config = {
					params: [form.getValues()],
					success: function(batch, option) {        
						var form  = Ext.getCmp('tab_calcuBasis').down('#calcuBasisSearch1');
						form.setValue('isCopy', 'N');
						UniAppManager.setToolbarButtons('save', false);   
					} 
				};     
				this.syncAllDirect(config);
			}else {
				panelDetail.down('#calcuBasisGrid1').uniSelectInvalidColumnAndAlert(inValidRecs);
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

	/* 품목별 배부율 등록 */
	//모델 정의
	Unilite.defineModel('cbm050ukrvModel2', {
	    fields: [
			{name: 'COMP_CODE'		, text: 'COMP_CODE'		, type : 'string', defaultValue: UserInfo.compCode},
			{name: 'DIV_CODE'		, text: 'DIV_CODE'		, type : 'string'},
			{name: 'WORK_MONTH'		, text: 'WORK_MONTH'	, type : 'string'},
			{name: 'ITEM_ACCOUNT'	, text: '품목계정'			, type : 'string'},
			{name: 'ITEM_CODE'		, text: '품목코드'			, type : 'string', allowBlank:false},
			{name: 'ITEM_NAME'		, text: '품목명'			, type : 'string', allowBlank:false},
			{name: 'SPEC'			, text: '규격'			, type : 'string', allowBlank:false},
			{name: 'DIST_RATE'		, text: '가중치'			, type : 'uniPrice'},
			{name: 'REMARK'			, text: '비고'			, type : 'string'}
		]
	});	

	//스토어 정의
	var cbm020ukrvStore2 = Unilite.createStore('cbm020ukrvStore2',{
		model: 'cbm050ukrvModel2',
        autoLoad: false,
        uniOpt : {
           	isMaster: true,			// 상위 버튼 연결 
           	editable: true,			// 수정 모드 사용 
           	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxy2,
        loadStoreRecords : function()	{
        	
			this.load({ 
			});
		},
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
		
			var rv = true;
		        
			if(inValidRecs.length == 0 ) {          
				config = {
					success: function(batch, option) {        
//					panelDetail.resetDirtyStatus();
					UniAppManager.setToolbarButtons('save', false);   
					} 
				};     
				this.syncAllDirect(config);
			}else {
				panelDetail.down('#cbm020ukrvsGrid2').uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		}    
	});

	/* 기준정보등록 */
	var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled : false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'cbm050Tab',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [{
		    	defaults:{
 					xtype:'uniDetailForm',
				    disabled:false,
					border:0,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
						margin: '10 10 10 10'
				},
				items:[
						<%@include file="./cbm120ukrv.jsp" %>	//월별배부기준등록
				]
	    	 }, {
		    	defaults:{
 					xtype:'uniDetailForm',
				    disabled:false,
					border:0,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
						margin: '10 10 10 10'
				},
				items:[
						<%@include file="./cbm300ukrv.jsp" %>	//품목별배부율등록 (cbm310ukrv -> cbm300ukrv 수정)
				]
			}],
			listeners: {
				beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
					if(Ext.isObject(oldCard))	{
						if(UniAppManager.app._needSave())	{
							if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
								UniAppManager.app.onSaveDataButtonDown();
								this.setActiveTab(oldCard);
							}else {
								UniAppManager.setToolbarButtons('save',false);
								UniAppManager.app.loadTabData(newCard, newCard.getItemId());							
							}
		    			 }else {
							UniAppManager.app.loadTabData(newCard, newCard.getItemId());							
		    			 }
		    		}
					else {
						if (newCard.itemId == 'tab_calcuBasis') {
							UniAppManager.setToolbarButtons(['reset','newData','delete'],false);
							UniAppManager.setToolbarButtons(['query','excel'],true);
							cbm050ukrvStore1.loadStoreRecords();
						}
						else if(newCard.itemId == 'tab_distRate'){
							UniAppManager.setToolbarButtons(['reset','delete'],false);
							UniAppManager.setToolbarButtons(['query','newData','excel'],true);
							cbm020ukrvStore2.loadStoreRecords();
						}
					 }
		    	}
		    }
	    }]
    })

	/* 기본정보등록	*/
	Unilite.Main( {
		id 			: 'cbm050ukrvApp',
		borderItems : [ 
			panelDetail		 	
		], 
		fnInitBinding : function() {				
			UniAppManager.setToolbarButtons(['reset','newData','delete'],false);
			UniAppManager.setToolbarButtons(['query','excel'],true);
		},
		onQueryButtonDown : function()	{		
			var activeTab = panelDetail.down('#cbm050Tab').getActiveTab();
			/* 월별배부기준등록 */
			if (activeTab.getItemId() == 'tab_calcuBasis'){
				UniAppManager.setToolbarButtons(['reset','newData','delete'],false);
				UniAppManager.setToolbarButtons(['query','excel'],true);
				cbm050ukrvStore1.loadStoreRecords();
			/* 품목별배부율등록 */
			} else if(activeTab.getItemId() == 'tab_distRate'){
				UniAppManager.setToolbarButtons(['reset','delete'],false);
				UniAppManager.setToolbarButtons(['query','newData','excel'],true);
				cbm020ukrvStore2.loadStoreRecords();
			}
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onNewDataButtonDown : function()	{
			var activeTab = panelDetail.down('#cbm050Tab').getActiveTab();

			/* Cost Center 추가버튼 클릭  */
//			if(activeTab.getItemId() == "tab_calcuBasis"){
//				var sortSeq			= 1;
//				var r = {
//					SORT_SEQ		: sortSeq
//				}
//				panelDetail.down('#cbm050ukrvsGrid1').createRow(r);
//			}
			/* Cost Pool 추가버튼 클릭  */
//			else if(activeTab.getId() == 'tab_distRate'){
//				var llcSeq			= 1;
//				var sortSeq			= 1;
//				var r = {
//					LLC_SEQ			: llcSeq,
//					SORT_SEQ		: sortSeq
//				}
//				panelDetail.down('#cbm050ukrvsGrid2').createRow(r);
//			}

		},
		onDeleteDataButtonDown : function()	{
			var activeTab = panelDetail.down('#cbm050Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_distRate"){
				panelDetail.down('#cbm020ukrvsGrid2').deleteSelectedRow();
			}	
		},		
		onSaveDataButtonDown: function () {
			var activeTab = panelDetail.down('#cbm050Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_calcuBasis"){
				cbm050ukrvStore1.saveStore();
			}
			else if(activeTab.getItemId() == "tab_distRate"){
				cbm020ukrvStore2.saveStore();
			}	
		},
		loadTabData: function(tab, itemId){
			/* 월별배부기준등록 */
			if (tab.getItemId() == 'tab_calcuBasis'){
				UniAppManager.setToolbarButtons(['reset','newData','delete'],false);
				UniAppManager.setToolbarButtons(['query','excel'],true);
				panelDetail.down('#calcuBasisGrid1').getStore().loadData({});
				cbm050ukrvStore1.loadStoreRecords();
			}
			/* 품목별배부율등록 */
			else if (tab.getItemId() == 'tab_distRate'){
				UniAppManager.setToolbarButtons(['reset','delete'],false);
				UniAppManager.setToolbarButtons(['query','newData','excel'],true);
				panelDetail.down('#cbm020ukrvsGrid2').getStore().loadData({});
				cbm020ukrvStore2.loadStoreRecords();
			}
		}
	});
	
	Unilite.createValidator('validator01', {
		store : cbm050ukrvStore1,
		grid:  panelDetail.down('#calcuBasisGrid1'),
		validate: function( type, fieldName, newValue, oldValue, record, ePanel, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			var sAccnt = record.get("ACCNT");
			
			if(fieldName=='SUM_STND_CD')	{
				if(newValue != '')	{
					if( newValue != "04" ) {					//'관리항목정보가 아닌 경우
						record.set("MANAGE_CODE1", "");			//'집계관리항목1=""으로 변경
						record.set("MANAGE_CODE2", "");			//'집계관리항목2=""으로 변경
					}
	
					if( newValue != "06" ) {					//'수불정보가 아닌 경우
						record.set("INOUT_TYPE_DETAIL", "");	//'수불유형=""으로 변경
					}
				}
	
				Ext.each(this.store.getData().items, function(rec, idx){
					if (rec.get("ACCNT") == sAccnt)		{
						rec.set("SUM_STND_CD", newValue);
						rec.set("AMT_STND_CD", record.get("AMT_STND_CD"));
						rec.set("MANAGE_CODE1", record.get("MANAGE_CODE1"));
						rec.set("MANAGE_CODE2", record.get("MANAGE_CODE2"));
						rec.set("INOUT_TYPE_DETAIL", record.get("INOUT_TYPE_DETAIL"));
					}
				})
			} else if( fieldName == 'AMT_STND_CD' ) {
				Ext.each(this.store.getData().items, function(rec, idx){
					if (rec.get("ACCNT") == sAccnt)		{
						rec.set("AMT_STND_CD", newValue);
					}
				});
			}else if( fieldName == 'MANAGE_CODE1' ) {		
				if(newValue != "")	{
					if(record.get("SUM_STND_CD") != "04" ) {						//관리항목정보가 아닌 경우
						alert(Msg.fsbMsgC0036)
						return false;
					}
				}
				Ext.each(this.store.getData().items, function(rec, idx){
					if (rec.get("ACCNT") == sAccnt)		{
						rec.set("MANAGE_CODE1", newValue);
	
					}
				});
				
			}else if( fieldName == 'MANAGE_CODE2' ) {		
				if(newValue != "")	{
					if(record.get("SUM_STND_CD") != "04")	{			//'관리항목정보가 아닌 경우
						alert(Msg.fsbMsgC0036);
						return false;
					}
				}
	
				Ext.each(this.store.getData().items, function(rec, idx){
					if(rec.get("ACCNT") == sAccnt) {
						rec.set("MANAGE_CODE2", newValue);
					}
				});
			}else if( fieldName == 'INOUT_TYPE_DETAIL' ) {		
				if(newValue != "")	{
					if(record.get("SUM_STND_CD") != "06") {				//'수불정보가 아닌 경우
						alert(Msg.fsbMsgC0037);
						return false;
					}
				}
	
				Ext.each(this.store.getData().items, function(rec, idx){
					if(rec.get("ACCNT") == sAccnt)	{
						rec.set("INOUT_TYPE_DETAIL", newValue);
					}
				});
			}else if( fieldName == 'DISTR_STND_CD' ) {		
				if(newValue != "")	{
					if( !UniUtils.indexOf(newValue, ["01", "02", "03", "04", "05"]) ) {			//'배부유형이 직과가 아닌 경우
						record.set("CP_DIRECT_YN", "");	//'직과여부=""으로 변경
						record.set("DISTR_REFER_CD", "");	//'배부기준=""으로 변경
					}
				}
				Ext.each(this.store.getData().items, function(rec, idx){
					if(rec.get("ACCNT") == sAccnt) {
						rec.set("DISTR_STND_CD", newValue);
						rec.set("CP_DIRECT_YN", record.get("CP_DIRECT_YN"));
						rec.set("DISTR_REFER_CD", record.get("DISTR_REFER_CD"));
					}
				});
			}else if( fieldName == 'CP_DIRECT_YN' ) {		
	
				Ext.each(this.store.getData().items, function(rec, idx){
					if(rec.get("ACCNT") == sAccnt) {
						rec.set("CP_DIRECT_YN", newValue);
					}
				});
			}
				
			return rv;
		}
	});
};

</script>
