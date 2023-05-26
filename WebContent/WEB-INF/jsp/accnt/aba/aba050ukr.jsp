<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
	request.setAttribute("multiCompCode", ConfigUtil.getString("common.dataOption.multiCompCode", "false")); //multiCompCode 설정
%>
<t:appConfig pgmId="aba050ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 							<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A003" />					<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A004" />					<!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A012" />					<!-- 매입매출거래유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A054" opts= '${gsList}' />					<!-- 재무제표양식구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A079" />					<!-- 회계부서구분 -->
	
</t:appConfig>
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {
var gsList = '${gsList}';

var multiCompCode = '${multiCompCode}';
var multiCompCodeProxy;
var multiCompCodeProxy2;
var multiCompCodeProxy3;
var multiCompCodeProxy4;
var multiCompCodeProxy5;

    <c:if test="${multiCompCode == 'true'}">
     /* 회계담당자 */
     var multiCompCodeProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'aba051ukrService.select',
                create  : 'aba051ukrService.insertDetail',
                update  : 'aba051ukrService.updateDetail',
                destroy : 'aba051ukrService.deleteDetail',
                syncAll : 'aba051ukrService.saveAll'
            }
        });
     /* 매입매출거래유형 */
     var multiCompCodeProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'aba051ukrService.select2',
                create  : 'aba051ukrService.insertDetail2',
                update  : 'aba051ukrService.updateDetail',
                destroy : 'aba051ukrService.deleteDetail2',
                syncAll : 'aba051ukrService.saveAll2'
            }
        });
     /* 품목계정별항목코드 */   
     var multiCompCodeProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            api: {
                read    : 'aba051ukrService.select3',
//                create  : 'aba051ukrService.insertDetail3',
                update  : 'aba051ukrService.updateDetail',
//                destroy : 'aba051ukrService.deleteDetail3',
                syncAll : 'aba051ukrService.saveAll3'
            }
        });
	/* 사업기타소득지출유형(HS15) */
	var multiCompCodeProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba051ukrService.select4',
				create 	: 'aba051ukrService.insertDetail4',
				update 	: 'aba051ukrService.updateDetail',
				destroy	: 'aba051ukrService.deleteDetail4',
				syncAll	: 'aba051ukrService.saveAll4'
			}
	 });
	/* 경비유형(A177) */
	var multiCompCodeProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba051ukrService.select5',
				create 	: 'aba051ukrService.insertDetail5',
				update 	: 'aba051ukrService.updateDetail',
				destroy	: 'aba051ukrService.deleteDetail5',
				syncAll	: 'aba051ukrService.saveAll5'
			}
	 });
    </c:if>
	/* 회계담당자 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba050ukrService.select',
				create 	: 'aba050ukrService.insertDetail',
				update 	: 'aba050ukrService.updateDetail',
				destroy	: 'aba050ukrService.deleteDetail',
				syncAll	: 'aba050ukrService.saveAll'
			}
	 });
	/* 매입매출거래유형 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba050ukrService.select2',
				create 	: 'aba050ukrService.insertDetail2',
				update 	: 'aba050ukrService.updateDetail',
				destroy	: 'aba050ukrService.deleteDetail2',
				syncAll	: 'aba050ukrService.saveAll2'
			}
	 });
	/* 품목계정별항목코드 */
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba050ukrService.select3',
				update 	: 'aba050ukrService.updateDetail',
//				create 	: 'aba050ukrService.insertDetail3',
//				destroy	: 'aba050ukrService.deleteDetail3',
				syncAll	: 'aba050ukrService.saveAll3'
			}
	 });
	/* 사업기타소득지출유형(HS15) */
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba050ukrService.select4',
				create 	: 'aba050ukrService.insertDetail4',
				update 	: 'aba050ukrService.updateDetail',
				destroy	: 'aba050ukrService.deleteDetail4',
				syncAll	: 'aba050ukrService.saveAll4'
			}
	 });
	/* 경비유형(A177) */
	var directProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'aba050ukrService.select5',
				create 	: 'aba050ukrService.insertDetail5',
				update 	: 'aba050ukrService.updateDetail',
				destroy	: 'aba050ukrService.deleteDetail5',
				syncAll	: 'aba050ukrService.saveAll5'
			}
	 });

	/* Model 정의 
	 * @type 
	 */	
	//회계담당자 페이지 모델 정의
	Unilite.defineModel('aba050ukrsModel', {
	    fields:[{name: 'MAIN_CODE'			,text:'MAIN_CODE'		,type : 'string'},
	    		{name: 'SUB_CODE'			,text:'담당자코드'			,type : 'string',	allowBlank: false},
				{name: 'CODE_NAME'			,text:'담당자명'			,type : 'string',	allowBlank: false},
				{name: 'CODE_NAME_EN'		,text:'CODE_NAME_EN'	,type : 'string'},
				{name: 'CODE_NAME_CN'		,text:'CODE_NAME_CN'	,type : 'string'},
				{name: 'CODE_NAME_JP'		,text:'CODE_NAME_JP'	,type : 'string'},
				{name: 'USER_NAME'			,text:'사용자명'			,type : 'string'},
				{name: 'SYSTEM_CODE_YN'		,text:'SYSTEM_CODE_YN'	,type : 'int'},
				{name: 'REF_CODE1'			,text:'사용자ID'			,type : 'string',	allowBlank: false},
				{name: 'REF_CODE2'			,text:'사용부서'			,type : 'string',	allowBlank: false,	comboType: "AU", comboCode: "A079"	},
				{name: 'REF_CODE3'			,text:'REF_CODE3'		,type : 'string'},
				{name: 'REF_CODE4'			,text:'REF_CODE4'		,type : 'string'},
				{name: 'REF_CODE5'			,text:'REF_CODE5'		,type : 'string'},
				{name: 'SUB_LENGTH'			,text:'SUB_LENGTH'		,type : 'int'},
				{name: 'USE_YN'				,text:'USE_YN'			,type : 'string'},
				{name: 'SORT_SEQ'			,text:'SORT_SEQ'		,type : 'int'}
				//from aba010ukr.htm
			]
	});
	//회계담당자 페이지 스토어 정의
	var aba050ukrStore = Unilite.createStore('aba050ukrStore',{
		model: 'aba050ukrsModel',
//		autoLoad: true,
		uniOpt : {
        	isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: Ext.isEmpty(multiCompCodeProxy) ?  directProxy : multiCompCodeProxy,
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
//		    var toCreate = this.getNewRecords();
//			var toUpdate = this.getUpdatedRecords();
//			console.log("toUpdate",toUpdate);
		
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
				panelDetail.down('#aba050ukrsGrid').uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		},   
		loadStoreRecords : function(){
			var param= Ext.getCmp('tab_accntPrsnForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		} 
	});
	
	
	
	//매입매출거래유형 페이지 모델 정의
	Unilite.defineModel('aba050ukrModel2', {
	    fields: [{name: 'MAIN_CODE'			,text:'MAIN_CODE'		,type : 'string'},
				 {name: 'SUB_CODE'			,text:'거래유형코드'		,type : 'string',	allowBlank: false,		maxLength:2},
				 {name: 'CODE_NAME'			,text:'거래유형명'			,type : 'string',	allowBlank: false},
				 {name: 'CODE_NAME_EN'		,text:'CODE_NAME_EN'	,type : 'string'},
				 {name: 'CODE_NAME_CN'		,text:'CODE_NAME_CN'	,type : 'string'},
				 {name: 'CODE_NAME_JP'		,text:'CODE_NAME_JP'	,type : 'string'},
				 {name: 'USER_NAME'			,text:'사용자명'			,type : 'string'},
				 {name: 'SYSTEM_CODE_YN'	,text:'SYSTEM_CODE_YN'	,type : 'int'},
				 {name: 'REF_CODE1'			,text:'매입매출구분'		,type : 'string',	allowBlank: false,	comboType: "AU", comboCode: "A003"},
				 {name: 'REF_CODE2'			,text:'사용부서'			,type : 'string'},
				 {name: 'REF_CODE3'			,text:'REF_CODE3'		,type : 'string'},
				 {name: 'REF_CODE4'			,text:'REF_CODE4'		,type : 'string'},
				 {name: 'REF_CODE5'			,text:'REF_CODE5'		,type : 'string'},
				 {name: 'SUB_LENGTH'		,text:'SUB_LENGTH'		,type : 'int'},
				 {name: 'USE_YN'			,text:'USE_YN'			,type : 'string'},
				 {name: 'SORT_SEQ'			,text:'SORT_SEQ'		,type : 'int'} 
				 //from aba020ukr.htm
		]
	});
	//매입매출거래유형 페이지 스토어 정의
	var aba050ukrStore2 = Unilite.createStore('aba050ukrStore2',{
		model: 'aba050ukrModel2',
        autoLoad: true,
        uniOpt : {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: true,			// 삭제 가능 여부 
            useNavi		: false			// prev | next 버튼 사용
        },
        proxy: Ext.isEmpty(multiCompCodeProxy2) ?  directProxy2 : multiCompCodeProxy2,   
		loadStoreRecords : function(){
			var param =  panelDetail.down('#tab_busiTypeForm').getValues();
			this.load({
				params: param
			});
		},
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
		    var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();
			console.log("toUpdate",toUpdate);
		
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
				panelDetail.down('#aba050ukrsGrid2').uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		} 
	});
	
	
	
	//품목계정별항목코드 페이지 모델 정의
	Unilite.defineModel('aba050ukrModel3', {
	    fields: [{name: 'MAIN_CODE'				,text:'종합코드'		,type : 'string'},
				 {name: 'SUB_CODE'  			,text:'품목계정코드'		,type : 'string'},
				 {name: 'CODE_NAME' 			,text:'품목계정명'		,type : 'string'},
				 {name: 'CODE_NAME_EN' 			,text:'품목계정명'		,type : 'string'},
				 {name: 'CODE_NAME_CN' 			,text:'품목계정명'		,type : 'string'},
				 {name: 'CODE_NAME_JP' 			,text:'품목계정명'		,type : 'string'},
				 {name: 'REF_CODE1'  			,text:'집계항목'		,type : 'string',	comboType: "AU", comboCode: "A054"},
				 {name: 'REF_CODE2'				,text:'항목코드'		,type : 'string'	},
				 {name: 'REF_CODE3'				,text:'관련3'			,type : 'string'},
				 {name: 'REF_CODE4'				,text:'관련4'			,type : 'string'},
				 {name: 'REF_CODE5'				,text:'관련5'			,type : 'string'},
				 {name: 'SUB_LENGTH'			,text:'길이'			,type : 'int'},
				 {name: 'USE_YN'				,text:'사용여부'		,type : 'string',	comboType: "AU", comboCode: "A004"},
				 {name: 'SORT_SEQ'				,text:'정렬'			,type : 'int'},
				 {name: 'SYSTEM_CODE_YN'		,text:'시스템'			,type : 'int'}
				 //from aba045ukr.htm
		]
	});
	//품목계정별항목코드 페이지 스토어 정의
	var aba050ukrStore3 = Unilite.createStore('aba050ukrStore3',{
		model: 'aba050ukrModel3',
        autoLoad: true,
        uniOpt : {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: false,		// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: Ext.isEmpty(multiCompCodeProxy3) ?  directProxy3 : multiCompCodeProxy3,      
		loadStoreRecords : function(){
			this.load({
			});
		},
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
			var toUpdate = this.getUpdatedRecords();
			console.log("toUpdate",toUpdate);
		
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
				panelDetail.down('#aba050ukrsGrid3').uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		}    
	});	
	
	
	
	//사업기타소득지출유형(HS15) 페이지 모델 정의
	Unilite.defineModel('aba050ukrModel4', {
	    fields: [{name: 'MAIN_CODE'				,text:'종합코드'			,type : 'string'},
				 {name: 'SUB_CODE'  			,text:'계정구분코드'		,type : 'string'	 ,allowBlank:false		,maxLength: 2},
				 {name: 'CODE_NAME' 			,text:'계정구분명'			,type : 'string'	 ,allowBlank:false},
				 {name: 'CODE_NAME_EN' 			,text:'지출유형명'			,type : 'string'},
				 {name: 'CODE_NAME_CN' 			,text:'지출유형명'			,type : 'string'},
				 {name: 'CODE_NAME_JP' 			,text:'지출유형명'			,type : 'string'},
				 {name: 'REF_CODE1'  			,text:'사업기타소득자동기표'	,type : 'string'},
				 {name: 'REF_CODE2'				,text:'항목코드'			,type : 'string'},
				 {name: 'REF_CODE3'				,text:'관련3'				,type : 'string'},
				 {name: 'REF_CODE4'				,text:'관련4'				,type : 'string'},
				 {name: 'REF_CODE5'				,text:'관련5'				,type : 'string'},
				 {name: 'SUB_LENGTH'			,text:'길이'				,type : 'int'},
				 {name: 'USE_YN'				,text:'사용여부'			,type : 'string',	comboType: "AU", comboCode: "A004"},
				 {name: 'SORT_SEQ'				,text:'정렬'				,type : 'int'},
				 {name: 'SYSTEM_CODE_YN'		,text:'시스템'			,type : 'int'}
				 //from aba045ukr.htm
		]
	});
	//사업기타소득지출유형(HS15) 페이지 스토어 정의
	var aba050ukrStore4 = Unilite.createStore('aba050ukrStore4',{
		model: 'aba050ukrModel4',
        autoLoad: true,
        uniOpt : {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: Ext.isEmpty(multiCompCodeProxy4) ?  directProxy4 : multiCompCodeProxy4,      
		loadStoreRecords : function(){
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
				panelDetail.down('#aba050ukrsGrid4').uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		}    
	});
	
	
	
	
	//경비유형(A177) 페이지 모델 정의
	Unilite.defineModel('aba050ukrModel5', {
	    fields: [{name: 'MAIN_CODE'				,text:'종합코드'			,type : 'string'},
				 {name: 'SUB_CODE'  			,text:'경비유형코드'		,type : 'string'	 ,allowBlank:false},
				 {name: 'CODE_NAME' 			,text:'경비유형명'			,type : 'string'	 ,allowBlank:false},
				 {name: 'CODE_NAME_EN' 			,text:'경비유형명'			,type : 'string'},
				 {name: 'CODE_NAME_CN' 			,text:'경비유형명'			,type : 'string'},
				 {name: 'CODE_NAME_JP' 			,text:'경비유형명'			,type : 'string'},
				 {name: 'REF_CODE1'  			,text:'관련1'				,type : 'string'},
				 {name: 'REF_CODE2'				,text:'관련2'				,type : 'string'},
				 {name: 'REF_CODE3'				,text:'관련3'				,type : 'string'},
				 {name: 'REF_CODE4'				,text:'관련4'				,type : 'string'},
				 {name: 'REF_CODE5'				,text:'관련5'				,type : 'string'},
				 {name: 'SUB_LENGTH'			,text:'길이'				,type : 'int'},
				 {name: 'USE_YN'				,text:'사용여부'			,type : 'string',	comboType: "AU", comboCode: "A004"},
				 {name: 'SORT_SEQ'				,text:'정렬'				,type : 'int'},
				 {name: 'SYSTEM_CODE_YN'		,text:'시스템'			,type : 'int'}
				 //from aba045ukr.htm
		]
	});
	//경비유형(A177) 페이지 스토어 정의
	var aba050ukrStore5 = Unilite.createStore('aba050ukrStore5',{
		model: 'aba050ukrModel5',
        autoLoad: true,
        uniOpt : {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		proxy: Ext.isEmpty(multiCompCodeProxy5) ?  directProxy5 : multiCompCodeProxy5,      
		loadStoreRecords : function(){
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
				panelDetail.down('#aba050ukrsGrid5').uniSelectInvalidColumnAndAlert(inValidRecs);
		    }
		}    
	});
	
	
	
	var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled:false,
	    items : [{ 
	    	xtype: 'grouptabpanel',
	    	itemId: 'aba050Tab',
	    	activeGroup: 0,
	    	collapsible:true,
	    	items: [{
	    	 	defaults:{
					xtype:'uniDetailForm',
				    disabled:false,
				    border:0,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
					padding: '10 10 10 10'
				},
				items:[
					<%@include file="./aba050ukrs1.jsp" %>	//회계담당자
			    ]
	    	 }, {
	    	 	defaults:{
					xtype:'uniDetailForm',
				    disabled:false,
				    border:3,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
					padding: '10 10 10 10'
				},
				items:[
				    <%@include file="./aba050ukrs2.jsp" %>	//매입매출거래유형
			    ]
	    	 }, {
	    	 	defaults:{
					xtype:'uniDetailForm',
				    disabled:false,
				    border:0,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
					padding: '10 10 10 10'
				},
				items:[
				    <%@include file="./aba050ukrs3.jsp" %>	//픔목계정별항목코드
			    ]
			},{
	    	 	defaults:{
					xtype:'uniDetailForm',
				    disabled:false,
				    border:0,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
					padding: '10 10 10 10'
				},
				items:[
				    <%@include file="./aba050ukrs4.jsp" %>	//사업기타소득지출유형(HS15)
			    ]
			},{
	    	 	defaults:{
					xtype:'uniDetailForm',
				    disabled:false,
				    border:0,
				    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},		
					padding: '10 10 10 10'
				},
				items:[
				    <%@include file="./aba050ukrs5.jsp" %>	//경비구분(A177)
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
						if (newCard.itemId == 'tab_accntPrsn') {
							UniAppManager.setToolbarButtons(['reset'],false);
							UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
							if (oldCard !='tab_accntPrsn') {
								panelDetail.down('#tab_accntPrsnForm').clearForm();
								panelDetail.down('#aba050ukrsGrid').getStore().loadData({});
							}
//							aba050ukrStore.loadStoreRecords();
						}
						else if(newCard.itemId == 'tab_busiType'){
							UniAppManager.setToolbarButtons(['reset'],false);
							UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
							panelDetail.down('#tab_busiTypeForm').clearForm();
							panelDetail.down('#aba050ukrsGrid2').getStore().loadData({});
							panelDetail.down('#tab_busiTypeForm').setValue('SALE_DIVI', '1');
							aba050ukrStore2.loadStoreRecords();
						}
						else if(newCard.itemId == 'tab_itemAccntCode'){    			 	
							UniAppManager.setToolbarButtons(['query','newData','reset','delete'],false);
							UniAppManager.setToolbarButtons(['excel'],true);
							panelDetail.down('#aba050ukrsGrid3').getStore().loadData({});
							aba050ukrStore3.loadStoreRecords();
						 }	 	 	
						else if(newCard.itemId == 'tab_categoryAC'){    			 	
							UniAppManager.setToolbarButtons(['reset'],false);
							UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
							panelDetail.down('#aba050ukrsGrid4').getStore().loadData({});
							aba050ukrStore3.loadStoreRecords();
						 }	 	 	
					 }
		    	}
		    }
	    }]
    })
	
    
	 Unilite.Main( {
		id 			: 'aba050ukrApp',
		borderItems	: [ 
			panelDetail		 	
		], 
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset'],false);
			UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
			
			//페이지 오픈 시 포커스 설정
//			var activeTab = panelDetail.down('#aba050Tab').getActiveTab();
//			panelDetail.down('#tab_accntPrsnForm').onLoadSelectText('PRSN_CODE');;
		},
		
		onQueryButtonDown : function()	{		
			var activeTab = panelDetail.down('#aba050Tab').getActiveTab();
			/* 회계담당자 */
			if (activeTab.getItemId() == 'tab_accntPrsn'){
				if(!Ext.getCmp('tab_accntPrsnForm').getInvalidMessage()){
					return false;
				}
				UniAppManager.setToolbarButtons(['reset'],false);
				UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
				aba050ukrStore.loadStoreRecords();
			/* 매입매출거래유형 */
			} else if(activeTab.getItemId() == 'tab_busiType'){
				UniAppManager.setToolbarButtons(['reset'],false);
				UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
				aba050ukrStore2.loadStoreRecords();
			/* 품목계정별항목코드 */
			} else if(activeTab.getItemId() == 'tab_itemAccntCode'){	
				UniAppManager.setToolbarButtons(['query','newData','reset','delete'],false);
				UniAppManager.setToolbarButtons(['query','excel'],true);
				aba050ukrStore3.loadStoreRecords();
			/* 사업기타소득지출유형(HS15)  */
			} else if(activeTab.getItemId() == 'tab_categoryAC'){
				UniAppManager.setToolbarButtons(['reset'],false);
				UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
				aba050ukrStore4.loadStoreRecords();
			/* 경비구분(A177)  */
			} else if(activeTab.getItemId() == 'tab_categoryExpense'){
				UniAppManager.setToolbarButtons(['reset'],false);
				UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
				aba050ukrStore5.loadStoreRecords();
			}
/*			var viewLocked = tab.getActiveTab().lockedGrid.getView();
			var viewNormal = tab.getActiveTab().normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);*/
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
			var activeTab = panelDetail.down('#aba050Tab').getActiveTab();
			/* 회계담당자 추가버튼 클릭  */
			if(activeTab.getItemId() == "tab_accntPrsn"){
				var mainCode		= 'A009';
				var subCode			= '';
				var codeName		= '';
				var refCode1		= '';
				var userName		= '';
				var refCode2		= '1';
				var systemCodeYn	= 0;
				var subLength		= 2;
				var useYn			= 'Y';
				var sortSeq			= 1;
				var r = {
					MAIN_CODE		: mainCode,
					SUB_CODE		: subCode,
					CODE_NAME		: codeName,
					REF_CODE1		: refCode1,
					USER_NAME		: userName,
					REF_CODE2		: refCode2,
					SYSTEM_CODE_YN	: systemCodeYn,
					SUB_LENGTH		: subLength,
					USE_YN			: useYn,
					SORT_SEQ		: sortSeq
				}
				panelDetail.down('#aba050ukrsGrid').createRow(r);
			}	
			/* 매입매출거래유형 추가버튼 클릭  */
			else if(activeTab.getId() == 'tab_busiType'){
				var param 			= panelDetail.down('#tab_busiTypeForm').getValues();
				var mainCode		= 'A012';
				var systemCodeYn	= 0;
				var useYn			= 'Y';
				var sortSeq			= 1;
				var subLength		= 2;
				var r = {
					MAIN_CODE		: mainCode,
					SYSTEM_CODE_YN	: systemCodeYn,
					USE_YN			: useYn,
					SORT_SEQ		: sortSeq,
					SUB_LENGTH		: subLength
				}
				panelDetail.down('#aba050ukrsGrid2').createRow(r);
			}
			/* 품목계정별항목코드 추가버튼 클릭  */
			else if(activeTab.getId() == 'tab_itemAccntCd'){
				return false;
			}
			/* 사업기타소득지출유형(HS15)  */
			else if(activeTab.getItemId() == 'tab_categoryAC'){
//				var param 			= panelDetail.down('#tab_busiTypeForm').getValues();
				var mainCode		= 'HS15';
				var subCode			= '';
				var codeName		= '';
				var refCode1		= '';
				var systemCodeYn	= 0;
				var useYn			= 'Y';
				var sortSeq			= 1;
				var subLength		= 2;
				var r = {
					MAIN_CODE		: mainCode,
					SUB_CODE		: subCode,
					CODE_NAME		: codeName,
					REF_CODE1		: refCode1,
					SYSTEM_CODE_YN	: systemCodeYn,
					USE_YN			: useYn,
					SORT_SEQ		: sortSeq,
					SUB_LENGTH		: subLength
				}
				panelDetail.down('#aba050ukrsGrid4').createRow(r);
			}
			/* 경비구분(A177)  */
			else if(activeTab.getItemId() == 'tab_categoryExpense'){
//				var param 			= panelDetail.down('#tab_busiTypeForm').getValues();
				var mainCode		= 'A177';
				var subCode			= '';
				var codeName		= '';
				var refCode1		= '';
				var systemCodeYn	= 0;
				var useYn			= 'Y';
				var sortSeq			= 1;
				var subLength		= 2;
				var r = {
					MAIN_CODE		: mainCode,
					SUB_CODE		: subCode,
					CODE_NAME		: codeName,
					REF_CODE1		: refCode1,
					SYSTEM_CODE_YN	: systemCodeYn,
					USE_YN			: useYn,
					SORT_SEQ		: sortSeq,
					SUB_LENGTH		: subLength
				}
				panelDetail.down('#aba050ukrsGrid5').createRow(r);
			}
		},
		
		onDeleteDataButtonDown : function()	{
			var activeTab = panelDetail.down('#aba050Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_accntPrsn"){
				panelDetail.down('#aba050ukrsGrid').deleteSelectedRow();
				
			}else if(activeTab.getItemId() == "tab_busiType"){
				panelDetail.down('#aba050ukrsGrid2').deleteSelectedRow();
			}	
			else if(activeTab.getId() == 'tab_itemAccntCd'){									//품목계정별항목코드는 행 삭제 이벤트 안 됨
				return false;
			}
			else if(activeTab.getItemId() == "tab_categoryAC"){
				panelDetail.down('#aba050ukrsGrid4').deleteSelectedRow();
			}	
			else if(activeTab.getItemId() == "tab_categoryExpense"){
				panelDetail.down('#aba050ukrsGrid5').deleteSelectedRow();
			}	
		},		
		
		onSaveDataButtonDown: function () {
			var activeTab = panelDetail.down('#aba050Tab').getActiveTab();
			
			if(activeTab.getItemId() == "tab_accntPrsn"){
				aba050ukrStore.saveStore();
			}
			else if(activeTab.getItemId() == "tab_busiType"){
				aba050ukrStore2.saveStore();
			}	
			else if(activeTab.getId() == 'tab_itemAccntCd'){
				aba050ukrStore3.saveStore();
			}
			else if(activeTab.getItemId() == "tab_categoryAC"){
				aba050ukrStore4.saveStore();
			}	
			else if(activeTab.getItemId() == "tab_categoryExpense"){
				aba050ukrStore5.saveStore();
			}	
		},
		
		loadTabData: function(tab, itemId){
			/* 회계담당자 */
			if (tab.getItemId() == 'tab_accntPrsn'){
				UniAppManager.setToolbarButtons(['reset'],false);
				UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
				panelDetail.down('#tab_accntPrsnForm').clearForm();
				panelDetail.down('#aba050ukrsGrid').getStore().loadData({});
				panelDetail.down('#tab_accntPrsnForm').onLoadSelectText('PRSN_CODE');;
//				aba050ukrStore.loadStoreRecords();
			}
			
			/* 매입매출거래유형 */
			else if (tab.getItemId() == 'tab_busiType'){
				UniAppManager.setToolbarButtons(['reset'],false);
				UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
				panelDetail.down('#tab_busiTypeForm').clearForm();
				panelDetail.down('#aba050ukrsGrid2').getStore().loadData({});
				panelDetail.down('#tab_busiTypeForm').setValue('SALE_DIVI', '1');
				aba050ukrStore2.loadStoreRecords();
			}
			
			/* 품목계정별항목코드 */
			else if (tab.getItemId() == 'tab_itemAccntCode'){
				UniAppManager.setToolbarButtons(['newData','reset','delete'],false);
				UniAppManager.setToolbarButtons(['query', 'excel'],true);
				panelDetail.down('#aba050ukrsGrid3').getStore().loadData({});
				aba050ukrStore3.loadStoreRecords();
			}
			
			/*사업기타소득지출유형(HS15) */
			else if (tab.getItemId() == 'tab_categoryAC'){
				UniAppManager.setToolbarButtons(['reset'],false);
				UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
				UniAppManager.setToolbarButtons(['query', 'excel'],true);
				panelDetail.down('#aba050ukrsGrid4').getStore().loadData({});
				aba050ukrStore4.loadStoreRecords();
			}

			/*경비구분(A177) */
			else if (tab.getItemId() == 'tab_categoryExpense'){
				UniAppManager.setToolbarButtons(['reset'],false);
				UniAppManager.setToolbarButtons(['query','newData','delete','excel'],true);
				UniAppManager.setToolbarButtons(['query', 'excel'],true);
				panelDetail.down('#aba050ukrsGrid5').getStore().loadData({});
				aba050ukrStore5.loadStoreRecords();
			}

		}
	});
};
</script>
