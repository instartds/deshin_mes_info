<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
	<t:appConfig pgmId="hbs030ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A003" />	<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B018" />
	<t:ExtComboStore comboType="AU" comboCode="B010" />
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 보험구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H160" /> <!-- 근태구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H034" /> <!-- 근태구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H219" /> <!-- 근태구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H220" /> <!-- 비과세구분 -->
</t:appConfig>	
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<style type= "text/css">
.x-grid-cell {
    border-left: 0px !important;
    border-right: 0px !important;
}
.x-tree-icon-leaf {
    background-image:none;
}
.search-hr {
	height: 1px;
	border: 0;
	color: #fff;
	background-color: #330;
	width: 98%;
}
.x-grid-item-focused  .x-grid-cell-inner:before {
//    border: 0px; 
}
</style>
<script type="text/javascript" >

var excelWindow;	// 엑셀참조

function appMain() {     
	
	var hbs030ukrInsuranceStore = Ext.create('Ext.data.Store',{
		storeId: 'hbs030ukrInsuranceCombo',
        fields:[
        	'value',
        	'text'
        ],
        data:[
        	{'value':'1' , text:'<t:message code="system.label.human.anuinsuri" default="국민연금"/>'},
        	{'value':'2' , text:'<t:message code="system.label.human.healthinsur" default="건강보험"/>'},
        	{'value':'3' , text:'<t:message code="system.label.human.hireinsuri" default="고용보험"/>'}
        ]
	});
	
	// 엑셀참조
	Unilite.Excel.defineModel('excel.hbs030.sheet01', {
	    fields: [
			    {name: 'TAX_YYYY'						,text:'<t:message code="system.label.human.docyyyy" default="년도"/>'			,type : 'string'},
	    		{name: 'TAX_STRT_AMOUNT'		,text:'<t:message code="system.label.human.taxstrtamount" default="이상"/>'			,type : 'uniPrice',allowBlank:false},
	    		{name: 'TAX_END_AMOUNT'		,text:'<t:message code="system.label.human.taxendamount" default="미만"/>'			,type : 'uniPrice',allowBlank:false},
	    		{name: 'DED_GRADE1'					,text:'1'			,type : 'uniPrice'},
	    		{name: 'DED_GRADE2'					,text:'2'			,type : 'uniPrice'},
	    		{name: 'DED_GRADE3'					,text:'3-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE3_CHILD'		,text:'3-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE4'					,text:'4-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE4_CHILD'		,text:'4-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE5'					,text:'5-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE5_CHILD'		,text:'5-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE6'					,text:'6-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE6_CHILD'		,text:'6-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE7'					,text:'7-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE7_CHILD'		,text:'7-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE8'					,text:'8-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE8_CHILD'		,text:'8-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE9'					,text:'9-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
			    {name: 'DED_GRADE9_CHILD'		,text:'9-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE10'				,text:'10-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE10_CHILD'	,text:'10-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE11'				,text:'11-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE11_CHILD'	,text:'11-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'INSERT_USER_ID'				,text:'<t:message code="system.label.human.user" default="사용자"/>'		,type : 'string'  },
	    		{name: 'INSERT_DB_TIME'				,text:'<t:message code="system.label.human.useday1" default="사용일"/>'		,type : 'string'  }
		]
	});
	
	
	
	function openExcelWindow() {
		
			var me = this;
	        var vParam = {};
	        var appName = 'Unilite.com.excel.ExcelUploadWin';

            
            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 'hbs030',
                        grids: [{
                        		itemId: 'grid01',
                        		title: '<t:message code="system.label.human.simpleincometaxform" default="간이소득세액업로드양식"/>',                        		
                        		useCheckbox: false,
                        		model : 'excel.hbs030.sheet01',
                        		readApi: 'hbs030ukrService.selectExcelUploadSheet1',
                        		columns: [        
						        	{dataIndex: 'TAX_YYYY'			, width: 88, hidden: true}, 				
									{dataIndex: 'TAX_MONTH' 		, width: 88, hidden: true}, 			
									{dataIndex: 'TAX_STRT_AMOUNT' 	, width: 88}, 				
									{dataIndex: 'TAX_END_AMOUNT' 	, width: 88}, 	
									{dataIndex: 'DED_GRADE1' 		, width: 66}, 	
									{dataIndex: 'DED_GRADE2' 		, width: 66}, 	
									{dataIndex: 'DED_GRADE3' 		, width: 66}, 	
									{dataIndex: 'DED_GRADE3_CHILD' 	, width: 66}, 	
									{dataIndex: 'DED_GRADE4' 		, width: 66}, 	
									{dataIndex: 'DED_GRADE4_CHILD'  , width: 66}, 	
									{dataIndex: 'DED_GRADE5' 		, width: 66}, 	
									{dataIndex: 'DED_GRADE5_CHILD' 	, width: 66}, 	
									{dataIndex: 'DED_GRADE6' 		, width: 66}, 	
									{dataIndex: 'DED_GRADE6_CHILD' 	, width: 66}, 	
									{dataIndex: 'DED_GRADE7' 		, width: 66}, 	
									{dataIndex: 'DED_GRADE7_CHILD' 	, width: 66}, 	
									{dataIndex: 'DED_GRADE8' 		, width: 66}, 	
									{dataIndex: 'DED_GRADE8_CHILD' 	, width: 66}, 	
									{dataIndex: 'DED_GRADE9' 		, width: 66}, 	
									{dataIndex: 'DED_GRADE9_CHILD' 	, width: 66}, 	
									{dataIndex: 'DED_GRADE10' 		, width: 66}, 	
									{dataIndex: 'DED_GRADE10_CHILD' , width: 66}, 	
									{dataIndex: 'DED_GRADE11' 		, width: 66}, 	
									{dataIndex: 'DED_GRADE11_CHILD' , width: 66}, 	
									{dataIndex: 'UPDATE_DB_USER'	, width: 0, hidden: true}, 				
									{dataIndex: 'UPDATE_DB_TIME'	, width: 0, hidden: true}
								]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()	{
							excelWindow.getEl().mask('<t:message code="system.label.human.loading" default="로딩중..."/>','loading-indicator');		///////// 엑셀업로드 최신로직
                        	var me = this;
                        	var grid = this.down('#grid01');
                			var records = grid.getStore().getAt(0);	
				        	var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
							hbs030ukrService.selectExcelUploadSheet1(param, function(provider, response){
								var activeTab = panelDetail.down('#hbs030Tab').getActiveTab();
						    	var store = activeTab.down('#uniGridPanel4').getStore();
						    	var records = response.result;
						    	
						    	store.insert(0, records);
						    	console.log("response",response)
								excelWindow.getEl().unmask();
								grid.getStore().removeAll();
								me.hide();
						    });
                		}
                 });
            }
            excelWindow.center();
            excelWindow.show();
	}
	
	
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
			   read : 'hbs030ukrService.selectList1',
         	   create: 'hbs030ukrService.insertDetail1',
               update: 'hbs030ukrService.updateDetail1',
               destroy: 'hbs030ukrService.deleteDetail1',
               syncAll: 'hbs030ukrService.saveAll1'
			}
	 });
	 
	 var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
			   read : 'hbs030ukrService.selectList2',
         	   create: 'hbs030ukrService.insertDetail2',
               update: 'hbs030ukrService.updateDetail2',
               destroy: 'hbs030ukrService.deleteDetail2',
               syncAll: 'hbs030ukrService.saveAll2'
			}
	 });
	 
	 var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
			   read : 'hbs030ukrService.selectList3',
         	   create: 'hbs030ukrService.insertDetail3',
               update: 'hbs030ukrService.updateDetail3',
               destroy: 'hbs030ukrService.deleteDetail3',
               syncAll: 'hbs030ukrService.saveAll3'
			}
	 });
	 
	 var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
			   read : 'hbs030ukrService.selectList4',
         	   create: 'hbs030ukrService.insertDetail4',
               update: 'hbs030ukrService.updateDetail4',
               destroy: 'hbs030ukrService.deleteDetail4',
               syncAll: 'hbs030ukrService.saveAll4'
			}
	 });
	 
	 var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
			   read : 'hbs030ukrService.selectList5',
         	   create: 'hbs030ukrService.insertDetail5',
               update: 'hbs030ukrService.updateDetail5',
               destroy: 'hbs030ukrService.deleteDetail5',
               syncAll: 'hbs030ukrService.saveAll5'
			}
	 });
	 
	 var directProxy6 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
			    read : 'hbs030ukrService.selectList6',
        	    create: 'hbs030ukrService.insertDetail6',
       	        update: 'hbs030ukrService.updateDetail6',
        	    destroy: 'hbs030ukrService.deleteDetail6',
         	    syncAll: 'hbs030ukrService.saveAll6'
			}
	 });

	
	Unilite.defineModel('hbs030ukrs1Model', {//표준보수월액등록
	    fields: [
			    {name: 'STD_STRT_AMOUNT_I'			,text:'<t:message code="system.label.human.stdstrtamounti1" default="하한금액"/>'			,type : 'uniPrice' ,defaultValue: 0 },
	    		{name: 'STD_END_AMOUNT_I'			,text:'<t:message code="system.label.human.stdstrtamounti2" default="상한금액"/>'			,type : 'uniPrice' ,defaultValue: 0 },
	    		{name: 'INSUR_RATE'					,text:'<t:message code="system.label.human.rate" default="요율"/>(%)'			,type : 'float'  ,defaultValue: 0.000 ,decimalPrecision:4, format:'0,000.000'},
	    		{name: 'INSUR_RATE1'				,text:'<t:message code="system.label.human.rate" default="요율"/>1(%)'			,type : 'float'  ,defaultValue: 0.000 ,decimalPrecision:4, format:'0,000.000'},
	    		{name: 'REMARK'						,text:'<t:message code="system.label.human.estimate" default="금액산정"/>'			,type : 'string'},
				{name: 'INSUR_SEQ'					,text:'<t:message code="system.label.human.seqnum" default="순번"/>'				,type : 'string'},
	    		{name: 'INSUR_TYPE'					,text:'<t:message code="system.label.human.insurtype" default="보험구분"/>'			,type : 'string',store: Ext.data.StoreManager.lookup('hbs030ukrInsuranceCombo')},
	    		{name: 'BASE_YEAR'					,text:'<t:message code="system.label.human.baseyear" default="기준년도"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'				,text:'UPDATE_DB_USER'	,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'				,text:'UPDATE_DB_TIME'	,type : 'string'},
	    		{name: 'COMP_CODE'					,text:'COMP_CODE'		,type : 'string'}
			]
	});	

	var hbs030ukrs1Store = Unilite.createStore('hbs030ukrs1Store',{
			model: 'hbs030ukrs1Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            
            saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			console.log("inValidRecords : ", inValidRecs);
    			
    			var isErro = false;
    			var toCreate = this.getNewRecords();
	       		var toUpdate = this.getUpdatedRecords(); 
	       		
	       		var list = [].concat(toUpdate, toCreate);
				console.log("list:", list);
	
				Ext.each(list, function(record, index) {			// 저장 하기전 과세표준 값 비교
					if(record.data['STD_STRT_AMOUNT_I'] >= record.data['STD_END_AMOUNT_I']) {
						alert('<t:message code="system.message.human.message111" default="과세표준하한은 상한보다 작아야 합니다."/>');
						isErro = true;
						return false;								// 값이 클 경우 저장 안함
					}
				});			
    			if(!isErro){										 
	    			if(inValidRecs.length == 0 )	{
	    				config = {
							success: function(batch, option) {		
								UniAppManager.setToolbarButtons('save', false);								
								hbs030ukrs1Store.loadStoreRecords();	
							 } 
						};	
	    				this.syncAll(config);					
	    			}else {
	    				panelDetail.down('#uniGridPanel1').uniSelectInvalidColumnAndAlert(inValidRecs);
	    			}
    			}
            },
    		
             loadStoreRecords : function(){
		        var param =  panelDetail.down('#hbs030ukrPanel1Form').getValues();
		         this.load({
		            params: param
		         });
		    },
		    listeners: {
	        	load: function( store, records, successful, eOpts )	{
					var count = panelDetail.down('#uniGridPanel1').getStore().getCount();
					if(count == 0) {	
						alert('<t:message code="system.message.human.message112" default="자료가 없습니다"/>');
					}
				}
        	}
	});
	//종합소득세율등록
	Unilite.defineModel('hbs030ukrs2Model', {
	    fields: [
				{name: 'TAX_STD_LO_I'			,text:'<t:message code="system.label.human.taxstdloi" default="과세표준하한"/>'		,type : 'uniPrice'},
	    		{name: 'TAX_STD_HI_I'			,text:'<t:message code="system.label.human.taxstdhii" default="과세표준상한"/>'		,type : 'uniPrice',allowBlank:false},
	    		{name: 'TAX_RATE'				,text:'<t:message code="system.label.human.taxrate" default="세율"/>(%)'			,type : 'uniPrice',allowBlank:false, maxLength: 3}, // 셋째자리 수 까지만 입력 되야함.
	    		{name: 'ACCUM_SUB_I'			,text:'<t:message code="system.label.human.accumsubicong" default="누진금액"/>'			,type : 'uniPrice',allowBlank:false},
	    		{name: 'TAX_YEAR'				,text:'TAX_YEAR'		,type : 'string'}
			]
	});	
	
	var hbs030ukrs2Store = Unilite.createStore('hbs030ukrs2Store',{
			model: 'hbs030ukrs2Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy2,          
            
            saveStore : function()	{	
            	
            	
    			var inValidRecs = this.getInvalidRecords();
    			var isErro = false;
    			var toCreate = this.getNewRecords();
	       		var toUpdate = this.getUpdatedRecords(); 
	       		
	       		var list = [].concat(toUpdate, toCreate);
				console.log("list:", list);
	
				Ext.each(list, function(record, index) {
					if(record.data['TAX_STD_LO_I'] >= record.data['TAX_STD_HI_I']) {
						alert('<t:message code="system.message.human.message111" default="과세표준하한은 상한보다 작아야 합니다."/>');
						isErro = true;
						return false;
					}
				});		
    			console.log("inValidRecords : ", inValidRecs);
    			
    			if(!isErro){
	    			if(inValidRecs.length == 0 )	{
	    				config = {
							success: function(batch, option) {		
								UniAppManager.setToolbarButtons('save', false);								
								hbs030ukrs2Store.loadStoreRecords();	
							 } 
						};	
	    				this.syncAll(config);
	    			}else {
	    				panelDetail.down('#uniGridPanel2').uniSelectInvalidColumnAndAlert(inValidRecs);
	    			}
    			}
            },
            loadStoreRecords: function() {
    			var param = panelDetail.down('#hbs030ukrPanel2Form').getValues();	
    			console.log( param );
    			this.load({
    				params : param
    			});
    		}
	});
	
	//퇴직소득공제등록
	Unilite.defineModel('hbs030ukrs3Model', {
	    fields: [
			    {name: 'DUTY_YYYY'				,text:'<t:message code="system.label.human.yeardiff" default="근속년수"/>'			,type : 'uniPrice',allowBlank:false},
	    		{name: 'INCOME_SUB'			,text:'<t:message code="system.label.human.dedamounti" default="공제액"/>'			,type : 'uniPrice',allowBlank:false},
				{name: 'TAX_YEAR'				,text:'TAX_YEAR'		,type : 'string'}
	
	
			]
	});	

	var hbs030ukrs3Store = Unilite.createStore('hbs030ukrs3Store',{
			model: 'hbs030ukrs3Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy3,
           
            saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			console.log("inValidRecords : ", inValidRecs);
    			if(inValidRecs.length == 0 )	{
    				config = {
						success: function(batch, option) {		
							UniAppManager.setToolbarButtons('save', false);								
							hbs030ukrs3Store.loadStoreRecords();	
						 } 
					};	
    				this.syncAll(config);					
    			}else {
    				panelDetail.down('#uniGridPanel3').uniSelectInvalidColumnAndAlert(inValidRecs);
    			}
            },
            loadStoreRecords: function() {
    			var param = panelDetail.down('#hbs030ukrPanel3Form').getValues();	
    			console.log( param );
    			this.load({
    				params : param
    			});
    		}
            
	});
	
	//간이소득세액표
	Unilite.defineModel('hbs030ukrs4Model', {
	    fields: [
			    {name: 'TAX_YYYY'			,text:'<t:message code="system.label.human.docyyyy" default="년도"/>'			,type : 'string'},
	    		{name: 'TAX_STRT_AMOUNT'	,text:'<t:message code="system.label.human.taxstrtamount" default="이상"/>'			,type : 'uniPrice',allowBlank:false},
	    		{name: 'TAX_END_AMOUNT'		,text:'<t:message code="system.label.human.taxendamount" default="미만"/>'			,type : 'uniPrice',allowBlank:false},
	    		{name: 'DED_GRADE1'			,text:'1'			,type : 'uniPrice'},
	    		{name: 'DED_GRADE2'			,text:'2'			,type : 'uniPrice'},
	    		{name: 'DED_GRADE3'			,text:'3-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE3_CHILD'	,text:'3-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE4'			,text:'4-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE4_CHILD'	,text:'4-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE5'			,text:'5-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE5_CHILD'	,text:'5-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE6'			,text:'6-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE6_CHILD'	,text:'6-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE7'			,text:'7-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE7_CHILD'	,text:'7-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE8'			,text:'8-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE8_CHILD'	,text:'8-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE9'			,text:'9-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
			    {name: 'DED_GRADE9_CHILD'	,text:'9-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE10'		,text:'10-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE10_CHILD'	,text:'10-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE11'		,text:'11-<t:message code="system.label.human.general" default="일반"/>'		,type : 'uniPrice'},
	    		{name: 'DED_GRADE11_CHILD'	,text:'11-<t:message code="system.label.human.dedgrade" default="다자녀"/>'		,type : 'uniPrice'},
	    		{name: 'INSERT_USER_ID'		,text:'<t:message code="system.label.human.user" default="사용자"/>'		,type : 'string'  },
	    		{name: 'INSERT_DB_TIME'		,text:'<t:message code="system.label.human.useday1" default="사용일"/>'		,type : 'string'  }
	    
			]
	});	


	var hbs030ukrs4Store = Unilite.createStore('hbs030ukrs4Store',{
			model: 'hbs030ukrs4Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,		// 수정 모드 사용 
            	deletable:false,		// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy4,
            
            saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			console.log("inValidRecords : ", inValidRecs);
    			if(inValidRecs.length == 0 )	{
    				this.syncAll();					
    			}else {
    				panelDetail.down('#uniGridPanel4').uniSelectInvalidColumnAndAlert(inValidRecs);
    			}
            },
            loadStoreRecords: function() {
    			var param = panelDetail.down('#hbs030ukrPanel4Form').getValues();
    			
    			var SearchParam= {
					'TAX_YYYY'  : param.TAX_YYYY4.substring(0,4),
					'TAX_MONTH' : param.TAX_YYYY4.substring(4,6)
				}
    			console.log( SearchParam );
    			this.load({
    				params : SearchParam
    			});
    		},
    		listeners: {
	        	load: function( store, records, successful, eOpts )	{
	        		UniAppManager.setToolbarButtons(['delete'], false);
					var count = panelDetail.down('#uniGridPanel4').getStore().getCount();
					if(count > 0) {	
						panelDetail.down('#hbs030ukrPanel4Form').getField('TAX_YYYY4').setReadOnly(true);
						UniAppManager.setToolbarButtons(['reset', 'deleteAll'], true);
					}else{
						panelDetail.down('#hbs030ukrPanel4Form').getField('TAX_YYYY4').setReadOnly(false);
					}
				}
        	}    
	});
	
	//비과세
	Unilite.defineModel('hbs030ukrs5Model', {
	    fields: [
			    {name: 'COMP_CODE'						,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'},
	    		{name: 'TAX_YYYY'							,text:'<t:message code="system.label.human.taxyear" default="세액년도"/>'		,type : 'string'},
	    		{name: 'NONTAX_CODE'					,text:'<t:message code="system.label.human.nontaxcode" default="비과세코드"/>'		,type : 'string',allowBlank:false},
	    		{name: 'NONTAX_CODE_NAME'		,text:'<t:message code="system.label.human.nontaxcodename" default="비과세항목"/>'	,type : 'string',allowBlank:false},
	    		{name: 'PRINT_LOCATION'              ,text:'<t:message code="system.label.human.printlocation" default="기재란"/>'      ,type : 'string'},
	    		{name: 'TAX_EXEMP_KIND'              ,text:'<t:message code="system.label.human.type" default="구분"/>'      ,type : 'string', comboType: 'AU', comboCode: 'H220'},
	    		{name: 'TAX_EXEMP_LMT'				,text:'<t:message code="system.label.human.taxamountlmti" default="비과세한도액"/>'		,type : 'uniPrice'},
				{name: 'SEND_YN'								,text:'<t:message code="system.label.human.sendyn" default="자료제출여부"/>'	,type : 'string', comboType: 'AU', comboCode: 'H160',allowBlank:false},
	    		{name: 'LAW_PROVISION'				,text:'<t:message code="system.label.human.lawprovision" default="법조문"/>'		,type : 'string'},
	    		{name: 'INSERT_DB_USER'				,text:'<t:message code="system.label.human.user" default="사용자"/>'		,type : 'string'},
	    		{name: 'INSERT_DB_TIME'					,text:'<t:message code="system.label.human.useday1" default="사용일"/>'		,type : 'uniDate'},
	    		{name: 'UPDATE_DB_USER'				,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'		,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'				,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'		,type : 'uniDate'}
	    	
			]
	});	

	var hbs030ukrs5Store = Unilite.createStore('hbs030ukrs5Store',{
			model: 'hbs030ukrs5Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy5,
            
            saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			console.log("inValidRecords : ", inValidRecs);
    			if(inValidRecs.length == 0 )	{
    				config = {
						success: function(batch, option) {		
							UniAppManager.setToolbarButtons('save', false);								
							hbs030ukrs5Store.loadStoreRecords();	
						 } 
					};	
    				this.syncAll(config);	
    			}else {
    				panelDetail.down('#uniGridPanel5').uniSelectInvalidColumnAndAlert(inValidRecs);
    			}
            },
            loadStoreRecords: function() {
    			var param = panelDetail.down('#hbs030ukrPanel5Form').getValues();
    			console.log( param );
    			this.load({
    				params : param
    			});
    		},
    		listeners: {
	        	load: function( store, records, successful, eOpts )	{
					var count = panelDetail.down('#uniGridPanel5').getStore().getCount();
					if(count > 0) {	
						panelDetail.down('#hbs030ukrPanel5Form').getField('TAX_YYYY5').setReadOnly(true);
						UniAppManager.setToolbarButtons(['reset', 'deleteAll'], true);
					}else{
						panelDetail.down('#hbs030ukrPanel5Form').getField('TAX_YYYY5').setReadOnly(false);
					}
				}
        	}  
	});
	
	//원천징수신고코드등록
	Unilite.defineModel('hbs030ukrs6Model', {
	    fields: [
			    {name: 'COMP_CODE'			,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'},
	    		{name: 'TAX_YYYYMM'			,text:'TAX_YYYYMM'	,type : 'string'},
	    		{name: 'TAX_CODE'			,text:'<t:message code="system.label.human.withholdingcode" default="원천징수코드"/>'	,type : 'string',allowBlank:false},
	    		{name: 'TAX_CODE_NAME'		,text:'<t:message code="system.label.human.withholdingcodename" default="원천징수코드명"/>'	,type : 'string',allowBlank:false},
	    		{name: 'SORT_SEQ'			,text:'<t:message code="system.label.human.sortseq" default="정렬순서"/>'		,type : 'string',allowBlank:false},

				
				{name: 'COL_EDIT4'			,text:'4.인원'			,type : 'string', comboType: 'AU', comboCode: 'H219'},
				{name: 'COL_EDIT5'			,text:'5.총지급액'			,type : 'string', comboType: 'AU', comboCode: 'H219'},
				{name: 'COL_EDIT6'			,text:'6.소득세 등'			,type : 'string', comboType: 'AU', comboCode: 'H219'},
				{name: 'COL_EDIT7'			,text:'7.농어촌특별세'			,type : 'string', comboType: 'AU', comboCode: 'H219'},
				{name: 'COL_EDIT8'			,text:'8.가산세'			,type : 'string', comboType: 'AU', comboCode: 'H219'},
				{name: 'COL_EDIT9'			,text:'9.당월 조정</br>환급세액'			,type : 'string', comboType: 'AU', comboCode: 'H219'},
				{name: 'COL_EDIT10'			,text:'10.소득세 등</br>(가산세 포함)'			,type : 'string', comboType: 'AU', comboCode: 'H219'},
				{name: 'COL_EDIT11'			,text:'11.농어촌</br>특별세'			,type : 'string', comboType: 'AU', comboCode: 'H219'},
				
				{name: 'REF_CODE1'			,text:'거주비거주/사업기타'			,type : 'string'},
	    		{name: 'REF_CODE2'			,text:'이자배당/소득구분'			,type : 'string'},
				{name: 'REF_CODE3'			,text:'부표탭구분'		     	,type : 'string'},
				{name: 'REF_CODE4'          ,text:'이바배당구분(팝업)'         ,type : 'string'},
				
			    {name: 'INSERT_DB_USER'		,text:'<t:message code="system.label.human.user" default="사용자"/>'		,type : 'string'},
	    		{name: 'INSERT_DB_TIME'		,text:'<t:message code="system.label.human.useday1" default="사용일"/>'		,type : 'uniDate'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'		,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'		,type : 'uniDate'}

			]
	});	
	
	var hbs030ukrs6Store = Unilite.createStore('hbs030ukrs6Store',{
			model: 'hbs030ukrs6Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
             listeners: {
            	load: function(store){
            		if(store.getCount() > 0){
            		UniAppManager.setToolbarButtons('deleteAll',true);
            		}else{
            		UniAppManager.setToolbarButtons('deleteAll',false);
            	}
            
            	}
            }, 
            proxy: directProxy6,
            
            saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			console.log("inValidRecords : ", inValidRecs);
    			if(inValidRecs.length == 0 )	{
    				config = {
						success: function(batch, option) {		
							UniAppManager.setToolbarButtons('save', false);								
							hbs030ukrs5Store.loadStoreRecords();	
						 } 
					};	
    				this.syncAll(config);			
    			}else {
    				panelDetail.down('#uniGridPanel6').uniSelectInvalidColumnAndAlert(inValidRecs);
    			}
            },
            loadStoreRecords: function() {
    			var param = panelDetail.down('#hbs030ukrPanel6Form').getValues();
    			console.log( param );
    			this.load({
    				params : param
    			});
    		}
	});
	
	//법정기준자료연도이월
	Unilite.defineModel('hbs030ukrs7Model', {
	    fields: [
			    {name: 'COMP_CODE'			,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'},
	    		{name: 'TAX_YYYYMM'			,text:'TAX_YYYYMM'	,type : 'string'},
	    		{name: 'TAX_CODE'			,text:'<t:message code="system.label.human.withholdingcode" default="원천징수코드"/>'	,type : 'string'},
	    		{name: 'TAX_CODE_NAME'		,text:'<t:message code="system.label.human.withholdingcodename" default="원천징수코드명"/>'	,type : 'string'},
	    		{name: 'SORT_SEQ'			,text:'<t:message code="system.label.human.sortseq" default="정렬순서"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'			,text:'<t:message code="system.label.human.etc" default="기타"/>1'			,type : 'string'},
	    		{name: 'REF_CODE2'			,text:'<t:message code="system.label.human.etc" default="기타"/>2'			,type : 'string'},
				{name: 'REF_CODE3'			,text:'<t:message code="system.label.human.etc" default="기타"/>3'			,type : 'string'},
			
			    {name: 'INSERT_DB_USER'		,text:'<t:message code="system.label.human.user" default="사용자"/>'		,type : 'string'},
	    		{name: 'INSERT_DB_TIME'		,text:'<t:message code="system.label.human.useday1" default="사용일"/>'		,type : 'uniDate'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'		,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'		,type : 'uniDate'}
			]
	});	

	var hbs030ukrs7Store = Unilite.createStore('hbs030ukrs7Store',{
			model: 'hbs030ukrs7Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
        /*     proxy: {
                type: 'direct',
                api: {
                	//read : 'hbs030ukrService.doBatch',
             	   //create: 'hbs030ukrService.doBatch'
             	   //,update: 'hbs030ukrService.insertHbs030_7'
             	  
                }
            }, */
        
            loadStoreRecords: function() {
    			var param = panelDetail.down('#hbs030ukrPanel7Form').getValues();
    			console.log( param );
    			this.load({
    				params : param
    			});
    		}
	});
	
	var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'hbs030Tab',
	    	activeGroup: 0,
	    	//cls:'human-panel',
	    	collapsible:true,
	    	items: [
	    		{
		    	 	defaults:{
 						xtype:'uniDetailForm',
//						xtype:'uniGridPanel',
					    disabled:false,
					    border:3,
					    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
 						margin: '10 10 10 10'
					},
					items:[
						{
							title:'<t:message code="system.label.human.lavbaseupdate" default="법정기준등록"/>',
							itemId: 'tabTitle01',
							border: false						
						}
						,<%@include file="./hbs030ukrs1.jsp" %>	
						,<%@include file="./hbs030ukrs2.jsp" %>	
						,<%@include file="./hbs030ukrs3.jsp" %>	
						,<%@include file="./hbs030ukrs4.jsp" %>	
						,<%@include file="./hbs030ukrs5.jsp" %>	
						,<%@include file="./hbs030ukrs6.jsp" %>	
						,<%@include file="./hbs030ukrs7.jsp" %>	

				    ]
	    	 	}]
	    		,listeners:{	    			
			    	beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts ){
			    		if(Ext.isObject(oldCard))	{
			    			 if(UniAppManager.app._needSave())	{
			    				if(confirm('<t:message code="system.message.human.message074" default="내용이 변경되었습니다."/>' + "\n" + '<t:message code="system.message.human.message080" default="변경된 내용을 저장하시겠습니까?"/>'))	{	
			    					
			    					UniAppManager.app.onSaveDataButtonDown();
									this.setActiveTab(oldCard);									
								}else {
									//oldCard.down().getStore().rejectChanges();									
									UniAppManager.setToolbarButtons('save',false);
									UniAppManager.app.loadTabData(newCard, newCard.getItemId());	
									//alert(newCard.getItemId());
								}
			    			 }else{
			    			 	if (newCard.itemId == 'tabTitle01') {
		    						console.log('tab title clicked! do nothing');
		    						return false;
	    					 	}else{
	    					 		UniAppManager.app.fnInitBinding();
			    		            UniAppManager.app.loadTabData(newCard, newCard.getItemId());
	    					  }
			    	        }
			    		}
			    	},
			    	tabchange : function( grouptabPanel, newCard, oldCard, eOpts ){
			    		if(Ext.isObject(oldCard))	{
			    			 if(UniAppManager.app._needSave())	{
			    				if(confirm('<t:message code="system.message.human.message074" default="내용이 변경되었습니다."/>' + "\n" + '<t:message code="system.message.human.message080" default="변경된 내용을 저장하시겠습니까?"/>'))	{	
			    					
			    					UniAppManager.app.onSaveDataButtonDown();
									this.setActiveTab(oldCard);									
								}else {
									//oldCard.down().getStore().rejectChanges();									
									UniAppManager.setToolbarButtons('save',false);
									UniAppManager.app.loadTabData(newCard, newCard.getItemId());	
									//alert(newCard.getItemId());
								}
			    			 }else{
			    			 	if (newCard.itemId == 'tabTitle01') {
		    						console.log('tab title clicked! do nothing');
		    						return false;
	    					 	}else{
	    					 		UniAppManager.app.fnInitBinding();
			    		            UniAppManager.app.loadTabData(newCard, newCard.getItemId());
	    					  }
			    	        }
			    		}
			    	},
			    	afterrender:function()	{
						panelDetail.down('#hbs030Tab').setActiveTab(Ext.getCmp('hbs030ukrGrid1'));
					}
	    		} 
	    }]
    })
    
    function doBatch() {
        var param= Ext.getCmp('hbs030ukrGrid7').getValues();
		param.S_USER_ID = "${loginVO.userID}";
		console.log(param);
		Ext.Ajax.on("beforerequest", function(){ Ext.getBody().mask('<t:message code="system.label.human.loading" default="로딩중..."/>', 'loading') }, Ext.getBody());
		Ext.Ajax.on("requestcomplete", Ext.getBody().unmask, Ext.getBody());
		Ext.Ajax.on("requestexception", Ext.getBody().unmask, Ext.getBody());
		Ext.Ajax.request({
			url     : CPATH+'/human/doBatchHbs030ukr.do',
			params: param,
			success: function(response){
				data = Ext.decode(response.responseText);
				console.log(data);
				Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>','<t:message code="system.message.human.message113" default="법정기준 자료의 연도이월이 완료되었습니다."/>');
			}/* ,
			failure: function(response){
				console.log(response);
				Ext.Msg.alert('실패', '실행이 실패되었습니다.');
										} */
			});
        }

	 Unilite.Main( {
		borderItems:[ 
			panelDetail		 	
		], 
		id : 'hbs030ukrApp',
		fnInitBinding : function() {				
			UniAppManager.setToolbarButtons('query', true);
			UniAppManager.setToolbarButtons('newData', true);
			UniAppManager.setToolbarButtons('detail', false);
			UniAppManager.setToolbarButtons('reset', false);			
			UniAppManager.setToolbarButtons('deleteAll', false);
  			//hbs030ukrs1Store.loadStoreRecords();		
			
  			//panelDetail.down('#hbs030Tab').setActiveTab('hbs030ukrPanel1');  /* 메모리 스택부족 */ 인덱스, tab Object
		},
		loadTabData: function(tab, itemId, mainCode){			
			UniAppManager.setToolbarButtons('deleteAll',false);
			if(tab.getId() == 'hbs030ukrGrid1'){				
				if(!Ext.getCmp('hbs030ukrPanel1Form').getInvalidMessage()){
					return false;
				}
				
				var sForm = panelDetail.down('#hbs030ukrPanel1Form');
				
				hbs030ukrs1Store.loadStoreRecords();
				
				/*sForm.clearForm();
				panelDetail.down('#uniGridPanel1').reset();
				hbs030ukrs1Store.loadData({});
				
				sForm.setValue('BASE_YEAR', new Date().getFullYear());
				sForm.setValue('INSUR_TYPE', 1);
				
				hbs030ukrs1Store.loadStoreRecords();
				
				var focusField = sForm.getField('BASE_YEAR');
			 	focusField.focus(500);*/

			}else if(tab.getId() == 'hbs030ukrGrid2'){	
				var sForm = panelDetail.down('#hbs030ukrPanel2Form');
				sForm.clearForm();
				panelDetail.down('#uniGridPanel2').reset();
				hbs030ukrs2Store.loadData({});
				
				sForm.setValue('TAX_YEAR1', new Date().getFullYear());
				if(!Ext.getCmp('hbs030ukrPanel2Form').getInvalidMessage()){
					return false;
				}
				hbs030ukrs2Store.loadStoreRecords();
				
				var focusField = sForm.getField('TAX_YEAR1');
			 	focusField.focus(500);
				
			}else if(tab.getId() == 'hbs030ukrGrid3'){				
				if(!Ext.getCmp('hbs030ukrPanel3Form').getInvalidMessage()){
					return false;
				}
				hbs030ukrs3Store.loadStoreRecords();	
			}else if(tab.getId() == 'hbs030ukrGrid4'){
					var param={'S_COMP_CODE' : UserInfo.CompCode};
				hbs030ukrService.fnLoadMaxTaxYearMM(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						panelDetail.down('#hbs030ukrPanel4Form').setValue('TAX_YYYY4' ,provider[0].TAX_YYYYMM);
						//hbs030ukrs4Store.loadStoreRecords();	
						UniAppManager.setToolbarButtons(['newData', 'delete'], false);
					}
				});
			}else if(tab.getId() == 'hbs030ukrGrid5'){
				panelDetail.down('#hbs030ukrPanel5Form').getField('TAX_YYYY5').setReadOnly(false);
				panelDetail.down('#hbs030ukrPanel5Form').clearForm();
				panelDetail.down('#uniGridPanel5').reset();
				panelDetail.down('#hbs030ukrPanel5Form').setValue('TAX_YYYY5' ,new Date().getFullYear());
				UniAppManager.setToolbarButtons(['reset'], true);
				hbs030ukrs5Store.loadData({});
				//hbs030ukrs5Store.loadStoreRecords();	// 화면 로드시 조회 하지 않음
			}else if(tab.getId() == 'hbs030ukrGrid6'){	
				
				var param={'S_COMP_CODE' : UserInfo.CompCode};
				hbs030ukrService.checkMonth(param, function(provider, response) {
					if(!Ext.isEmpty(provider[0])) {
						panelDetail.down('#hbs030ukrPanel6Form').setValue('TAX_YYYYMM' ,provider[0].TAX_YYYYMM);
						if(!Ext.getCmp('hbs030ukrPanel6Form').getInvalidMessage()){
							return false;
						}
						hbs030ukrs6Store.loadStoreRecords();
						UniAppManager.setToolbarButtons(['deleteAll', 'reset'], true);
					}
				});
			}
			 else if(tab.getId() == 'hbs030ukrGrid7'){				
				UniAppManager.setToolbarButtons(['query', 'newData', 'delete', 'detail', 'reset', 'deleteAll'], false);		
			} 
		},
		onQueryButtonDown : function()	{			
		    var activeTabId = panelDetail.down('#hbs030Tab').getActiveTab();			
			if(activeTabId.getItemId() == 'hbs030ukrPanel1'){				
				if(!Ext.getCmp('hbs030ukrPanel1Form').getInvalidMessage()){
					return false;
				}
		    	hbs030ukrs1Store.loadStoreRecords();
    		}else if(activeTabId.getItemId() == 'hbs030ukrPanel2'){
				if(!Ext.getCmp('hbs030ukrPanel2Form').getInvalidMessage()){
					return false;
				}
    			hbs030ukrs2Store.loadStoreRecords();
    		}else if(activeTabId.getItemId() == 'hbs030ukrPanel3'){
				if(!Ext.getCmp('hbs030ukrPanel3Form').getInvalidMessage()){
					return false;
				}
    			hbs030ukrs3Store.loadStoreRecords();
    		}else if(activeTabId.getItemId()  == 'hbs030ukrPanel4'){
				if(!Ext.getCmp('hbs030ukrPanel4Form').getInvalidMessage()){
					return false;
				}
    			hbs030ukrs4Store.loadStoreRecords();
    		}else if(activeTabId.getItemId() == 'hbs030ukrPanel5'){
				if(!Ext.getCmp('hbs030ukrPanel5Form').getInvalidMessage()){
					return false;
				}
    			hbs030ukrs5Store.loadStoreRecords();
    		}else if(activeTabId.getItemId() == 'hbs030ukrPanel6'){ // 확인필요
				if(!Ext.getCmp('hbs030ukrPanel6Form').getInvalidMessage()){
					return false;
				}
    			hbs030ukrs6Store.loadStoreRecords();
    		}else if(activeTabId.getItemId() == 'hbs030ukrPanel7'){
				if(!Ext.getCmp('hbs030ukrPanel7Form').getInvalidMessage()){
					return false;
				}
    			//hbs030ukrs7Store.loadStoreRecords();
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
		onNewDataButtonDown : function() {			
			var activeTab = panelDetail.down('#hbs030Tab').getActiveTab();
	        	switch(activeTab.getItemId()){
			case 'hbs030ukrPanel1' :
				activeTab.down('#uniGridPanel1').createRow(
					{INSUR_SEQ : hbs030ukrs1Store.getCount() + 1, BASE_YEAR: Ext.getCmp('BASE_YEAR').getValue(), INSUR_TYPE:Ext.getCmp('INSUR_TYPE').getValue(), 
					 STD_STRT_AMOUNT_I: 0, STD_END_AMOUNT_I : 0 , INSUR_RATE : 0.000 , INSUR_RATE1 : 0.000, COMP_CODE : UserInfo.compCode
					},'INSUR_SEQ',0);
				break;
			case 'hbs030ukrPanel2' :
				activeTab.down('#uniGridPanel2').createRow({ TAX_YEAR : Ext.getCmp('TAX_YEAR1').getValue() },'',0);
				break;
			case 'hbs030ukrPanel3' :
				activeTab.down('#uniGridPanel3').createRow({ TAX_YEAR : Ext.getCmp('TAX_YEAR2').getValue() },'',0);
				break;
			case 'hbs030ukrPanel4' :
				activeTab.down('#uniGridPanel4').createRow({ TAX_YYYY : Ext.getCmp('TAX_YYYY4').getValue() },'',0);
				break;
			case 'hbs030ukrPanel5' :
				activeTab.down('#uniGridPanel5').createRow({COMP_CODE : UserInfo.compCode, TAX_YYYY : Ext.getCmp('TAX_YYYY5').getValue() },'',0);
				break;
			case 'hbs030ukrPanel6' :
				 var TAX_YYYYMM = Ext.getCmp('TAX_YYYYMM').getValue();
				 var TAX_YYYY = TAX_YYYYMM.getFullYear();
		         var TAX_MM = TAX_YYYYMM.getMonth() + 1;
		         TAX_MM = (TAX_MM > 9 ? TAX_MM : '0' + TAX_MM)
				activeTab.down('#uniGridPanel6').createRow({ TAX_YYYYMM  :TAX_YYYY+TAX_MM },'',0);
				break;
			/* case 'hbs030ukrPanel7' :
				activeTab.down('#uniGridPanel7').createRow();
				break; */
			default:
				break;
			} 
		},
		onSaveDataButtonDown: function (config) {
			var activeTab = panelDetail.down('#hbs030Tab').getActiveTab();
			switch(activeTab.getItemId()){
			case 'hbs030ukrPanel1' :
				if(activeTab.down('#uniGridPanel1').getStore().isDirty()){
					activeTab.down('#uniGridPanel1').getStore().saveStore(config);
				}
				break;
			case 'hbs030ukrPanel2' :
				if(activeTab.down('#uniGridPanel2').getStore().isDirty()){
					activeTab.down('#uniGridPanel2').getStore().saveStore(config);
				}
				break;
			case 'hbs030ukrPanel3' :
				if(activeTab.down('#uniGridPanel3').getStore().isDirty()){
					activeTab.down('#uniGridPanel3').getStore().saveStore(config);
				}
				break;
			case 'hbs030ukrPanel4' :
				if(activeTab.down('#uniGridPanel4').getStore().isDirty()){
					activeTab.down('#uniGridPanel4').getStore().saveStore(config);
				
				}
				break;
			case 'hbs030ukrPanel5' :
				if(activeTab.down('#uniGridPanel5').getStore().isDirty()){
					activeTab.down('#uniGridPanel5').getStore().saveStore(config);
				}
				break;
			case 'hbs030ukrPanel6' :
				if(activeTab.down('#uniGridPanel6').getStore().isDirty()){
					activeTab.down('#uniGridPanel6').getStore().saveStore(config);
				}
				break;
			/* case 'hbs030ukrPanel7' :
				if(activeTab.down('#uniGridPanel7').getStore().isDirty()){
					activeTab.down('#uniGridPanel7').getStore().sync();
				}
				break; */
			default:
				break;
			}
		},
		confirmDelete : function(activeTab,index){
			var gridPanel = '#uniGridPanel';
			gridPanel = gridPanel + index;			
			var selRow = activeTab.down(gridPanel).getSelectedRecord();
			if(selRow.phantom === true)	{
				activeTab.down(gridPanel).deleteSelectedRow();
			}else{
				activeTab.down(gridPanel).deleteSelectedRow();
			}
		},
		onDeleteAllButtonDown : function() {				
					var activeTabId = panelDetail.down('#hbs030Tab').getActiveTab().getId();				
					if(activeTabId == 'hbs030ukrGrid4'){
						if(confirm('<t:message code="system.message.human.message060" default="전체 삭제하시겠습니까?"/>'))	{
							hbs030ukrs4Store.removeAll();
							hbs030ukrs4Store.syncAll({
									success: function(response){
										data = Ext.decode(response.responseText);
										console.log(data);
										Ext.Msg.alert('<t:message code="system.label.human.completion" default="완료"/>','<t:message code="system.message.human.message114" default="전체삭제가 완료되었습니다."/>');
	
										UniAppManager.setToolbarButtons('save',false);
										UniAppManager.setToolbarButtons('deleteAll',false);		
										UniAppManager.app.onResetButtonDown();
									},
									failure: function(response){
										console.log(response);
										Ext.Msg.alert('<t:message code="system.label.human.fail" default="실패"/>', response.statusText);
									}	
								}	
							);
						}
					}else if(activeTabId == 'hbs030ukrGrid5'){
						if(confirm('<t:message code="system.message.human.message060" default="전체 삭제하시겠습니까?"/>'))	{
							hbs030ukrs5Store.removeAll();
							hbs030ukrs5Store.syncAll({
									success: function(response){
										data = Ext.decode(response.responseText);
										console.log(data);
										Ext.Msg.alert('<t:message code="system.label.human.completion" default="완료"/>','<t:message code="system.message.human.message114" default="전체삭제가 완료되었습니다."/>');
										UniAppManager.app.onResetButtonDown();
										UniAppManager.setToolbarButtons('save',false);
										UniAppManager.setToolbarButtons('deleteAll',false);
									},
									failure: function(response){
										console.log(response);
										Ext.Msg.alert('<t:message code="system.label.human.fail" default="실패"/>', response.statusText);
									}	
								}	
							);
						}
					}else if(activeTabId == 'hbs030ukrGrid6'){
						if(confirm('<t:message code="system.message.human.message060" default="전체 삭제하시겠습니까?"/>'))	{
							hbs030ukrs6Store.removeAll();
							hbs030ukrs6Store.syncAll({
									success: function(response){
										data = Ext.decode(response.responseText);
										console.log(data);
										Ext.Msg.alert('<t:message code="system.label.human.completion" default="완료"/>','<t:message code="system.message.human.message114" default="전체삭제가 완료되었습니다."/>');
										UniAppManager.app.onResetButtonDown();
										UniAppManager.setToolbarButtons('save',false);
										UniAppManager.setToolbarButtons('deleteAll',false);
									},
									failure: function(response){
										console.log(response);
										Ext.Msg.alert('<t:message code="system.label.human.fail" default="실패"/>', response.statusText);
									}	
								}	
							);
						}
					}
					 /* else if(activeTabId == 'hbs030ukrGrid5'){				
						hbs030ukrs5Store.removeAll();
						hbs030ukrs5Store.sync();
					}else if(activeTabId == 'hbs030ukrGrid6'){				
						hbs030ukrs6Store.removeAll();
						hbs030ukrs6Store.sync();
					} *//* else if(activeTabId == 'hbs030ukrGrid7'){				
						hbs030ukrs7Store.removeAll();
						hbs030ukrs7Store.sync();
					} */
			
	/* 	}
	});	 */		
},
		onDeleteDataButtonDown : function()	{
			var activeTab = panelDetail.down('#hbs030Tab').getActiveTab();
						
			switch(activeTab.getItemId()){
			case 'hbs030ukrPanel1' :
				this.confirmDelete(activeTab,1);
				break;
			case 'hbs030ukrPanel2' :
				this.confirmDelete(activeTab,2);
				break;
			case 'hbs030ukrPanel3' :
				this.confirmDelete(activeTab,3);
				break;
			case 'hbs030ukrPanel4' :
				this.confirmDelete(activeTab,4);
				break;
			case 'hbs030ukrPanel5' :
				this.confirmDelete(activeTab,5);
				break;
			case 'hbs030ukrPanel6' :
				this.confirmDelete(activeTab,6);
				break;
			default:
				break;
			}
			
		},
		onResetButtonDown:function() {
			var activeTab = panelDetail.down('#hbs030Tab').getActiveTab();
			
			/* 간이소득세액표 */
			if (activeTab.getItemId() == 'hbs030ukrPanel4'){
				var param={'S_COMP_CODE' : UserInfo.CompCode};
				hbs030ukrService.fnLoadMaxTaxYearMM(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						panelDetail.down('#hbs030ukrPanel4').clearForm();
						panelDetail.down('#uniGridPanel4').getStore().loadData({});
						panelDetail.down('#hbs030ukrPanel4').getField('TAX_YYYY4').setReadOnly(false);
						panelDetail.down('#hbs030ukrPanel4').setValue('TAX_YYYY4' ,provider[0].TAX_YYYYMM);
						UniAppManager.setToolbarButtons(['newData', 'delete', 'save'], false);
					}
				});
			}
			else if(activeTab.getItemId() == 'hbs030ukrPanel5'){
				panelDetail.down('#hbs030ukrPanel5').clearForm();
				panelDetail.down('#uniGridPanel5').getStore().loadData({});
				panelDetail.down('#hbs030ukrPanel5').getField('TAX_YYYY5').setReadOnly(false);
				panelDetail.down('#hbs030ukrPanel5').setValue('TAX_YYYY5' ,new Date().getFullYear());
				UniAppManager.setToolbarButtons(['deleteAll', 'save'], false);
			}
			else if(activeTab.getItemId() == 'hbs030ukrPanel6'){
				var param={'S_COMP_CODE' : UserInfo.CompCode};
				hbs030ukrService.checkMonth(param, function(provider, response) {
					if(!Ext.isEmpty(provider)) {
						panelDetail.down('#hbs030ukrPanel6').clearForm();
						panelDetail.down('#uniGridPanel6').getStore().loadData({});
						panelDetail.down('#hbs030ukrPanel6').getField('TAX_YYYYMM').setReadOnly(false);
						panelDetail.down('#hbs030ukrPanel6').setValue('TAX_YYYYMM' ,provider[0].TAX_YYYYMM);
						UniAppManager.setToolbarButtons(['deleteAll', 'save'], false);
						//hbs030ukrs6Store.loadStoreRecords();
						//UniAppManager.setToolbarButtons('deleteAll',true); 임시로 기능 제거
					}
				});
			}
			//this.fnInitBinding();
		}
		
		/*checkForNewDetail1:function() { 			
			return panelDetail.down('#hbs030ukrPanel1').setAllFieldsReadOnly(true);
        },
        checkForNewDetail2:function() { 			
			return panelDetail.down('#hbs030ukrPanel2').setAllFieldsReadOnly(true);
        },
		checkForNewDetail3:function() { 			
			return panelDetail.down('#hbs030ukrPanel3').setAllFieldsReadOnly(true);
		},
		checkForNewDetail4:function() { 			
			return panelDetail.down('#hbs030ukrPanel4').setAllFieldsReadOnly(true);
		},
		checkForNewDetail5:function() { 			
			return panelDetail.down('#hbs030ukrPanel5').setAllFieldsReadOnly(true);
		},
		checkForNewDetail6:function() { 			
			return panelDetail.down('#hbs030ukrPanel6').setAllFieldsReadOnly(true);
		},
		checkForNewDetail7:function() { 			
			return panelDetail.down('#hbs030ukrPanel7').setAllFieldsReadOnly(true);
		}*/
	 

	});

	
	Unilite.createValidator('validator01', {
		grid: panelDetail.down('#uniGridPanel1'),
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			//하한금액
				case "STD_STRT_AMOUNT_I" :
					if(newValue < 0){
						rv='<t:message code="system.message.human.message049" default="양수만 입력가능합니다."/>';
						break;
					}
				break;
			//상한금액	
				case "STD_END_AMOUNT_I" :
					if(newValue < 0){
						rv='<t:message code="system.message.human.message049" default="양수만 입력가능합니다."/>';
						break;
					}
				break;
			 //	요율(%)
				case "INSUR_RATE" :
					if(newValue < 0){
						rv='<t:message code="system.message.human.message049" default="양수만 입력가능합니다."/>';
						break;
					}
				break;
			 //	요율1(%)	
				case "INSUR_RATE1" :
					if(newValue < 0){
						rv='<t:message code="system.message.human.message049" default="양수만 입력가능합니다."/>';
						break;
					}
				break;
			}
			return rv;
			}
		});
		
	Unilite.createValidator('validator02', {
		grid: panelDetail.down('#uniGridPanel2'),
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			//과세표준하한
				case "TAX_STD_LO_I" :
					if(newValue < 0){
						rv='<t:message code="system.message.human.message049" default="양수만 입력가능합니다."/>';
						break;
					}
				break;
			//과세표준상한
				case "TAX_STD_HI_I" :
					if(newValue < 0){
						rv='<t:message code="system.message.human.message049" default="양수만 입력가능합니다."/>';
						break;
					}
				break;
			 //	세율(%)
				case "TAX_RATE" :
					if(newValue < 0){
						rv='<t:message code="system.message.human.message049" default="양수만 입력가능합니다."/>';
						break;
					}
				break;
			 //	누진금액
				case "ACCUM_SUB_I" :
					if(newValue < 0){
						rv='<t:message code="system.message.human.message049" default="양수만 입력가능합니다."/>';
						break;
					}
				break;
			}
			return rv;
			}
		});
		
	Unilite.createValidator('validator03', {
		grid: panelDetail.down('#uniGridPanel3'),
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			//근속년수
				case "DUTY_YYYY" :
					if(newValue < 0){
						rv='<t:message code="system.message.human.message049" default="양수만 입력가능합니다."/>';
						break;
					}
				break;
			//공제액
				case "INCOME_SUB" :
					if(newValue < 0){
						rv='<t:message code="system.message.human.message049" default="양수만 입력가능합니다."/>';
						break;
					}
				break;
			}
			return rv;
			}
		});	
		
	Unilite.createValidator('validator06', {
		grid: panelDetail.down('#uniGridPanel6'),
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			//정렬순서
				case "SORT_SEQ" :
					if(newValue < 0){
						rv='<t:message code="system.message.human.message049" default="양수만 입력가능합니다."/>';
						break;
					}
				break;
			}
			return rv;
			}
		});
};

</script>
