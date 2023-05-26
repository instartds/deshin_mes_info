<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="hbs010ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A003" />	<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B018" />
	<t:ExtComboStore comboType="AU" comboCode="B010" />
</t:appConfig>	
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >

function appMain() {    
	
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
		    read	: 'hbs010ukrService.selectList',
        	create	: 'hbs010ukrService.insertHbs010',
        	update	: 'hbs010ukrService.updateHbs010',
        	destroy	: 'hbs010ukrService.deleteHbs010',
        	syncAll	: 'hbs010ukrService.syncAll'
		}
	});

	//직위등록명
	Unilite.defineModel('hbs010ukrs1Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'					,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string', allowBlank:false, isPk:true,  pkGen:'user', readOnly:false},
	    		{name: 'CODE_NAME'				,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string', allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'					,text:'<t:message code="system.label.human.officergubun" default="임원구분"/>'		,type : 'boolean'},
// 				{xtype : 'fieldcontainer'	, text:'임원구분' 		,defaultType: 'checkboxfield', items:[{ name: 'REF_CODE1',inputValue: '1'}]},
	    		{name: 'REF_CODE2'					,text:'<t:message code="system.label.human.refer" default="관련"/>2'			,type : 'string'},
	    		{name: 'REF_CODE3'					,text:'<t:message code="system.label.human.refer" default="관련"/>3'			,type : 'string'},
	    		{name: 'REF_CODE4'					,text:'<t:message code="system.label.human.refer" default="관련"/>4'			,type : 'string'},
	    		{name: 'REF_CODE5'					,text:'<t:message code="system.label.human.refer" default="관련"/>5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text:'<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
				{name: 'USE_YN'						,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string', xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},					
	    		{name: 'SORT_SEQ'					,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]			
	});	
	
	 
	var hbs010ukrs1Store = Unilite.createStore('hbs010ukrs1Store',{
			model: 'hbs010ukrs1Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {				
            	var param= { MAIN_CODE : 'H005'};    			
    			this.load({
    				params: param
    			});
    		},
            saveStore : function()	{				
    			var inValidRecs = this.getInvalidRecords();
    			if(inValidRecs.length == 0 )	{
    				this.syncAll();					
    			}else {    				
    				panelDetail.down('#uniGridPanel1').uniSelectInvalidColumnAndAlert(inValidRecs);
    			}
    		}
	});

	//직책명
	Unilite.defineModel('hbs010ukrs2Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text: '<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'					,text: '<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'				,text: '<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'	, allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text: '<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text: '<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text: '<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'					,text: '<t:message code="system.label.human.rank" default="직급"/>(HP01)'	,type : 'string'},
	    		{name: 'REF_CODE2'					,text: '<t:message code="system.label.human.refer" default="관련"/>2'		,type : 'string'},
	    		{name: 'REF_CODE3'					,text: '<t:message code="system.label.human.refer" default="관련"/>3'		,type : 'string'},
	    		{name: 'REF_CODE4'					,text: '<t:message code="system.label.human.refer" default="관련"/>4'		,type : 'string'},
	    		{name: 'REF_CODE5'					,text: '<t:message code="system.label.human.refer" default="관련"/>5'		,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text: '<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'						,text: '<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string'	,  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'					,text: '<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text: '<t:message code="system.label.human.system" default="시스템"/>'		,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.human.updateuser" default="수정자"/>'		,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.human.updatedate" default="수정일"/>'		,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text: '<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	
	
	var hbs010ukrs2Store = Unilite.createStore('hbs010ukrs2Store',{
			model: 'hbs010ukrs2Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H006'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	//담당업무명
	Unilite.defineModel('hbs010ukrs3Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'					,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string', allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'				,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string', allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'					,text:'<t:message code="system.label.human.refer" default="관련"/>1'		,type : 'string'},
	    		{name: 'REF_CODE2'					,text:'<t:message code="system.label.human.refer" default="관련"/>2'		,type : 'string'},
	    		{name: 'REF_CODE3'					,text:'<t:message code="system.label.human.refer" default="관련"/>3'			,type : 'string'},
	    		{name: 'REF_CODE4'					,text:'<t:message code="system.label.human.refer" default="관련"/>4'			,type : 'string'},
	    		{name: 'REF_CODE5'					,text:'<t:message code="system.label.human.refer" default="관련"/>5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text:'<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'						,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string', xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'					,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	

	var hbs010ukrs3Store = Unilite.createStore('hbs010ukrs3Store',{
			model: 'hbs010ukrs3Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H008'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	//학력코드
	Unilite.defineModel('hbs010ukrs4Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text: '<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'					,text: '<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string', allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'				,text: '<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string', allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text: '<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text: '<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text: '<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'					,text: '<t:message code="system.label.human.refer" default="관련"/>1'		,type : 'string'},
	    		{name: 'REF_CODE2'					,text: '<t:message code="system.label.human.refer" default="관련"/>2'		,type : 'string'},
	    		{name: 'REF_CODE3'					,text: '<t:message code="system.label.human.refer" default="관련"/>3'		,type : 'string'},
	    		{name: 'REF_CODE4'					,text: '<t:message code="system.label.human.refer" default="관련"/>4'		,type : 'string'},
	    		{name: 'REF_CODE5'					,text: '<t:message code="system.label.human.refer" default="관련"/>5'		,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text: '<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'						,text: '<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string', xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'					,text: '<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text: '<t:message code="system.label.human.system" default="시스템"/>'		,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.human.updateuser" default="수정자"/>'		,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.human.updatedate" default="수정일"/>'		,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text: '<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	

	var hbs010ukrs4Store = Unilite.createStore('hbs010ukrs4Store',{
			model: 'hbs010ukrs4Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H009'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	//졸업구분
	Unilite.defineModel('hbs010ukrs5Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'					,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string', allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'				,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string', allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'					,text:'<t:message code="system.label.human.refer" default="관련"/>1'			,type : 'string'},
	    		{name: 'REF_CODE2'					,text:'<t:message code="system.label.human.refer" default="관련"/>2'			,type : 'string'},
	    		{name: 'REF_CODE3'					,text:'<t:message code="system.label.human.refer" default="관련"/>3'			,type : 'string'},
	    		{name: 'REF_CODE4'					,text:'<t:message code="system.label.human.refer" default="관련"/>4'			,type : 'string'},
	    		{name: 'REF_CODE5'					,text:'<t:message code="system.label.human.refer" default="관련"/>5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text:'<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'						,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'					,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	

	var hbs010ukrs5Store = Unilite.createStore('hbs010ukrs5Store',{
			model: 'hbs010ukrs5Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H010'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	//입사코드
	Unilite.defineModel('hbs010ukrs6Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'					,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string', allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'				,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string', allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'					,text:'<t:message code="system.label.human.refer" default="관련"/>1'		,type : 'string'},
	    		{name: 'REF_CODE2'					,text:'<t:message code="system.label.human.refer" default="관련"/>2'		,type : 'string'},
	    		{name: 'REF_CODE3'					,text:'<t:message code="system.label.human.refer" default="관련"/>3'			,type : 'string'},
	    		{name: 'REF_CODE4'					,text:'<t:message code="system.label.human.refer" default="관련"/>4'			,type : 'string'},
	    		{name: 'REF_CODE5'					,text:'<t:message code="system.label.human.refer" default="관련"/>5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text:'<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'						,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string',  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'					,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	
	
	var hbs010ukrs6Store = Unilite.createStore('hbs010ukrs6Store',{
			model: 'hbs010ukrs6Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H012'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	//병역구분
	Unilite.defineModel('hbs010ukrs7Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'					,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'				,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'	, allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'					,text:'<t:message code="system.label.human.refer" default="관련"/>1'			,type : 'string'},
	    		{name: 'REF_CODE2'					,text:'<t:message code="system.label.human.refer" default="관련"/>2'			,type : 'string'},
	    		{name: 'REF_CODE3'					,text:'<t:message code="system.label.human.refer" default="관련"/>3'			,type : 'string'},
	    		{name: 'REF_CODE4'					,text:'<t:message code="system.label.human.refer" default="관련"/>4'			,type : 'string'},
	    		{name: 'REF_CODE5'					,text:'<t:message code="system.label.human.refer" default="관련"/>5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text:'<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'						,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string'	,  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'					,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	

	
	var hbs010ukrs7Store = Unilite.createStore('hbs010ukrs7Store',{
			model: 'hbs010ukrs7Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H016'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	//병역군별
	Unilite.defineModel('hbs010ukrs8Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'					,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'				,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'	, allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'					,text:'<t:message code="system.label.human.refer" default="관련"/>1'			,type : 'string'},
	    		{name: 'REF_CODE2'					,text:'<t:message code="system.label.human.refer" default="관련"/>2'			,type : 'string'},
	    		{name: 'REF_CODE3'					,text:'<t:message code="system.label.human.refer" default="관련"/>3'			,type : 'string'},
	    		{name: 'REF_CODE4'					,text:'<t:message code="system.label.human.refer" default="관련"/>4'			,type : 'string'},
	    		{name: 'REF_CODE5'					,text:'<t:message code="system.label.human.refer" default="관련"/>5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text:'<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'						,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string'	,  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'					,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	

	var hbs010ukrs8Store = Unilite.createStore('hbs010ukrs8Store',{
			model: 'hbs010ukrs8Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H017'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	//병역계급
	Unilite.defineModel('hbs010ukrs9Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'					,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'				,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'	, allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'					,text:'<t:message code="system.label.human.refer" default="관련"/>1'			,type : 'string'},
	    		{name: 'REF_CODE2'					,text:'<t:message code="system.label.human.refer" default="관련"/>2'			,type : 'string'},
	    		{name: 'REF_CODE3'					,text:'<t:message code="system.label.human.refer" default="관련"/>3'			,type : 'string'},
	    		{name: 'REF_CODE4'					,text:'<t:message code="system.label.human.refer" default="관련"/>4'			,type : 'string'},
	    		{name: 'REF_CODE5'					,text:'<t:message code="system.label.human.refer" default="관련"/>5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text:'<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'						,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string'	, xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'					,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	

	var hbs010ukrs9Store = Unilite.createStore('hbs010ukrs9Store',{
			model: 'hbs010ukrs9Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H018'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	//병역병과
	Unilite.defineModel('hbs010ukrs10Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'					,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'				,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'	, allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'					,text:'<t:message code="system.label.human.refer" default="관련"/>1'			,type : 'string'},
	    		{name: 'REF_CODE2'					,text:'<t:message code="system.label.human.refer" default="관련"/>2'			,type : 'string'},
	    		{name: 'REF_CODE3'					,text:'<t:message code="system.label.human.refer" default="관련"/>3'			,type : 'string'},
	    		{name: 'REF_CODE4'					,text:'<t:message code="system.label.human.refer" default="관련"/>4'			,type : 'string'},
	    		{name: 'REF_CODE5'					,text:'<t:message code="system.label.human.refer" default="관련"/>5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text:'<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'						,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string'	,  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'					,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	

	var hbs010ukrs10Store = Unilite.createStore('hbs010ukrs10Store',{
			model: 'hbs010ukrs10Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H019'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	//퇴직사유
	Unilite.defineModel('hbs010ukrs11Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'					,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'				,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'	, allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'					,text:'<t:message code="system.label.human.refer" default="관련"/>1'			,type : 'string'},
	    		{name: 'REF_CODE2'					,text:'<t:message code="system.label.human.refer" default="관련"/>2'			,type : 'string'},
	    		{name: 'REF_CODE3'					,text:'<t:message code="system.label.human.refer" default="관련"/>3'			,type : 'string'},
	    		{name: 'REF_CODE4'					,text:'<t:message code="system.label.human.refer" default="관련"/>4'			,type : 'string'},
	    		{name: 'REF_CODE5'					,text:'<t:message code="system.label.human.refer" default="관련"/>5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text:'<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'						,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string'	, xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'					,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	

	var hbs010ukrs11Store = Unilite.createStore('hbs010ukrs11Store',{
			model: 'hbs010ukrs11Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H023'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	//사원구분
	Unilite.defineModel('hbs010ukrs12Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'			,type : 'string'},
	    		{name: 'SUB_CODE'					,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'			,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'				,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'			,type : 'string'	, allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'			,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'			,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'			,type : 'string'},
	    		{name: 'REF_CODE1'					,text:'<t:message code="system.label.human.staffgroupcode" default="사원그룹코드"/>(H181)'	,type : 'string'},
	    		{name: 'REF_CODE2'					,text:'<t:message code="system.label.human.transportver" default="운수버젼(운전직구분)"/>'	,type : 'string'},
	    		{name: 'REF_CODE3'					,text:'<t:message code="system.label.human.refer" default="관련"/>3'				,type : 'string'},
	    		{name: 'REF_CODE4'					,text:'<t:message code="system.label.human.payprovflag2" default="지급차수"/>(H031)'		,type : 'string'},
	    		{name: 'REF_CODE5'					,text:'<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>(h028)'	,type : 'string'},
	    		{name: 'REF_CODE6'					,text:'<t:message code="system.label.human.cumbenttype" default="직구분"/>'				,type : 'string'},	//(0:임원, 1:일반, 2:기능, 3:전문, 4:상근, 5:전임강사)
	    		{name: 'REF_CODE7'					,text:'<t:message code="system.label.human.staffnotinclude" default="인원현황제외"/>(Y)'		,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text:'<t:message code="system.label.human.length" default="길이"/>'				,type : 'string'},
	    		{name: 'USE_YN'						,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'			,type : 'string'	, xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'					,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'				,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'				,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'				,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'				,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'			,type : 'string'}
			]
	});	

	var hbs010ukrs12Store = Unilite.createStore('hbs010ukrs12Store',{
			model: 'hbs010ukrs12Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H024'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	// 직렬코드등록
	Unilite.defineModel('hbs010ukrs18Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'			,type : 'string'},
	    		{name: 'SUB_CODE'					,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'			,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'				,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'			,type : 'string'	, allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'			,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'			,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'			,type : 'string'},
	    		{name: 'REF_CODE1'					,text:'<t:message code="system.label.human.staffgroupcode" default="사원그룹코드"/>(H181)'	,type : 'string'},
	    		{name: 'REF_CODE2'					,text:'<t:message code="system.label.human.transportver" default="운수버젼(운전직구분)"/>'	,type : 'string'},
	    		{name: 'REF_CODE3'					,text:'<t:message code="system.label.human.refer" default="관련"/>3'				,type : 'string'},
	    		{name: 'REF_CODE4'					,text:'<t:message code="system.label.human.payprovflag2" default="지급차수"/>(H031)'		,type : 'string'},
	    		{name: 'REF_CODE5'					,text:'<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>(h028)'	,type : 'string'},
	    		{name: 'REF_CODE6'					,text:'<t:message code="system.label.human.cumbenttype" default="직구분"/>'				,type : 'string'},	//(0:임원, 1:일반, 2:기능, 3:전문, 4:상근, 5:전임강사)
	    		{name: 'REF_CODE7'					,text:'<t:message code="system.label.human.staffnotinclude" default="인원현황제외"/>(Y)'		,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text:'<t:message code="system.label.human.length" default="길이"/>'				,type : 'string'},
	    		{name: 'USE_YN'						,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'			,type : 'string'	, xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'					,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'				,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'				,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'				,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'				,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'			,type : 'string'}
			]
	});	

	var hbs010ukrs18Store = Unilite.createStore('hbs010ukrs18Store',{
			model: 'hbs010ukrs18Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H173'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();

				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});
	
	// 직종코드등록
	Unilite.defineModel('hbs010ukrs19Model', {
	    fields: [
			    {name: 'MAIN_CODE'				,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'			,type : 'string'},
	    		{name: 'SUB_CODE'					,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'			,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'				,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'			,type : 'string'	, allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'			,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'			,type : 'string'},
	    		{name: 'CODE_NAME_JP'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'			,type : 'string'},
	    		{name: 'REF_CODE1'					,text:'<t:message code="system.label.human.staffgroupcode" default="사원그룹코드"/>(H181)'	,type : 'string'},
	    		{name: 'REF_CODE2'					,text:'<t:message code="system.label.human.transportver" default="운수버젼(운전직구분)"/>'	,type : 'string'},
	    		{name: 'REF_CODE3'					,text:'<t:message code="system.label.human.refer" default="관련"/>3'				,type : 'string'},
	    		{name: 'REF_CODE4'					,text:'<t:message code="system.label.human.payprovflag2" default="지급차수"/>(H031)'		,type : 'string'},
	    		{name: 'REF_CODE5'					,text:'<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>(h028)'	,type : 'string'},
	    		{name: 'REF_CODE6'					,text:'<t:message code="system.label.human.cumbenttype" default="직구분"/>'				,type : 'string'},	//(0:임원, 1:일반, 2:기능, 3:전문, 4:상근, 5:전임강사)
	    		{name: 'REF_CODE7'					,text:'<t:message code="system.label.human.staffnotinclude" default="인원현황제외"/>(Y)'		,type : 'string'},
	    		{name: 'SUB_LENGTH'				,text:'<t:message code="system.label.human.length" default="길이"/>'				,type : 'string'},
	    		{name: 'USE_YN'						,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'			,type : 'string'	, xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'					,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'				,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'				,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'				,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'				,type : 'uniDate'},
	    		{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'			,type : 'string'}
			]
	});	

	var hbs010ukrs19Store = Unilite.createStore('hbs010ukrs19Store',{
			model: 'hbs010ukrs19Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H072'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});
	
	//지급차수
	Unilite.defineModel('hbs010ukrs13Model', {
	    fields: [
			    {name: 'MAIN_CODE'			,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'			,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'			,text:'<t:message code="system.label.human.dutydeadline" default="근태집계마감일"/>'		,type : 'string'},
	    		{name: 'REF_CODE2'			,text:'<t:message code="system.label.human.paydeadline" default="급여집계마감일"/>'		,type : 'string'},
	    		{name: 'REF_CODE3'			,text:'<t:message code="system.label.human.refer" default="관련"/>3'			,type : 'string'},
	    		{name: 'REF_CODE4'			,text:'<t:message code="system.label.human.refer" default="관련"/>4'			,type : 'string'},
	    		{name: 'REF_CODE5'			,text:'<t:message code="system.label.human.refer" default="관련"/>5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'			,text:'<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'				,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string'	, xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'			,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'			,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	

	var hbs010ukrs13Store = Unilite.createStore('hbs010ukrs13Store',{
			model: 'hbs010ukrs13Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H031'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	//지급구분
	Unilite.defineModel('hbs010ukrs14Model', {
	    fields: [
			    {name: 'MAIN_CODE'			,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'			,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'	, allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'			,text:'<t:message code="system.label.human.supptype" default="지급구분"/>(1:<t:message code="system.label.human.salary" default="급여"/>)'	,type : 'string'},
	    		{name: 'REF_CODE2'			,text:'<t:message code="system.label.human.printseq" default="출력순서"/>'		,type : 'string'},
	    		{name: 'REF_CODE3'			,text:'<t:message code="system.label.human.refer" default="관련"/>3'			,type : 'string'},
	    		{name: 'REF_CODE4'			,text:'<t:message code="system.label.human.refer" default="관련"/>4'			,type : 'string'},
	    		{name: 'REF_CODE5'			,text:'<t:message code="system.label.human.refer" default="관련"/>5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'			,text:'<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'				,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string'	, xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'			,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'			,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	

	var hbs010ukrs14Store = Unilite.createStore('hbs010ukrs14Store',{
			model: 'hbs010ukrs14Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H032'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	//기타소득코드
	Unilite.defineModel('hbs010ukrs15Model', {
	    fields: [
			    {name: 'MAIN_CODE'			,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'			,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'	, allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'			,text:'<t:message code="system.label.human.refer" default="관련"/>1'			,type : 'string'},
	    		{name: 'REF_CODE2'			,text:'<t:message code="system.label.human.refer" default="관련"/>2'			,type : 'string'},
	    		{name: 'REF_CODE3'			,text:'<t:message code="system.label.human.refer" default="관련"/>3'			,type : 'string'},
	    		{name: 'REF_CODE4'			,text:'<t:message code="system.label.human.refer" default="관련"/>4'			,type : 'string'},
	    		{name: 'REF_CODE5'			,text:'<t:message code="system.label.human.refer" default="관련"/>5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'			,text:'<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'				,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string'	,  xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'			,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'			,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	

	var hbs010ukrs15Store = Unilite.createStore('hbs010ukrs15Store',{
			model: 'hbs010ukrs15Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H039'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}        
	});
	
	//주민세관할관청
	Unilite.defineModel('hbs010ukrs16Model', {
	    fields: [
			    {name: 'MAIN_CODE'			,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'			,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'	, allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'			,text:'<t:message code="system.label.human.refer" default="관련"/>1'			,type : 'string'},
	    		{name: 'REF_CODE2'			,text:'<t:message code="system.label.human.refer" default="관련"/>2'			,type : 'string'},
	    		{name: 'REF_CODE3'			,text:'<t:message code="system.label.human.refer" default="관련"/>3'			,type : 'string'},
	    		{name: 'REF_CODE4'			,text:'<t:message code="system.label.human.refer" default="관련"/>4'			,type : 'string'},
	    		{name: 'REF_CODE5'			,text:'<t:message code="system.label.human.refer" default="관련"/>5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'			,text:'<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'				,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string'	, xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'			,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'			,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	

	var hbs010ukrs16Store = Unilite.createStore('hbs010ukrs16Store',{
			model: 'hbs010ukrs16Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H137'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	//금융기관코드
	Unilite.defineModel('hbs010ukrs17Model', {
	    fields: [
			    {name: 'MAIN_CODE'			,text:'<t:message code="system.label.human.maincode1" default="종합코드"/>'		,type : 'string'},
	    		{name: 'SUB_CODE'			,text:'<t:message code="system.label.human.subcode1" default="상세코드"/>'		,type : 'string'	, allowBlank:false, isPk:true,  pkGen:'user', readOnly:true},
	    		{name: 'CODE_NAME'			,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'	, allowBlank:false},
	    		{name: 'CODE_NAME_EN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_CN'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'CODE_NAME_JP'		,text:'<t:message code="system.label.human.subcodename" default="상세코드명"/>'		,type : 'string'},
	    		{name: 'REF_CODE1'			,text:'<t:message code="system.label.human.refer" default="관련"/>1'			,type : 'string'},
	    		{name: 'REF_CODE2'			,text:'<t:message code="system.label.human.refer" default="관련"/>2'			,type : 'string'},
	    		{name: 'REF_CODE3'			,text:'<t:message code="system.label.human.refer" default="관련"/>3'			,type : 'string'},
	    		{name: 'REF_CODE4'			,text:'<t:message code="system.label.human.refer" default="관련"/>4'			,type : 'string'},
	    		{name: 'REF_CODE5'			,text:'<t:message code="system.label.human.refer" default="관련"/>5'			,type : 'string'},
	    		{name: 'SUB_LENGTH'			,text:'<t:message code="system.label.human.length" default="길이"/>'			,type : 'string'},
	    		{name: 'USE_YN'				,text:'<t:message code="system.label.human.useyn" default="사용여부"/>'		,type : 'string'	, xtype: 'uniCombobox', comboType: 'AU', comboCode: 'B010'},
	    		{name: 'SORT_SEQ'			,text:'<t:message code="system.label.human.btnSort" default="정렬"/>'			,type : 'string'},
	    		{name: 'SYSTEM_CODE_YN'		,text:'<t:message code="system.label.human.system" default="시스템"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.human.updateuser" default="수정자"/>'			,type : 'string'},
	    		{name: 'UPDATE_DB_TIME'		,text:'<t:message code="system.label.human.updatedate" default="수정일"/>'			,type : 'uniDate'},
	    		{name: 'COMP_CODE'			,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type : 'string'}
			]
	});	

	var hbs010ukrs17Store = Unilite.createStore('hbs010ukrs17Store',{
			model: 'hbs010ukrs17Model',
            autoLoad: false,
            uniOpt : {
            	isMaster	: true,			// 상위 버튼 연결 
            	editable	: true,			// 수정 모드 사용 
            	deletable	: true,			// 삭제 가능 여부 
	            useNavi 	: false			// prev | next 버튼 사용
            },
            
            proxy: directProxy1,
            loadStoreRecords: function() {
//     			var param= Ext.getCmp('searchForm').getValues();
				var param= { MAIN_CODE : 'H099'};
    			console.log( param );
    			this.load({
    				params: param
    			});
    		},
    		saveStore : function(activeTab)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					activeTab.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}            
	});
	
	
	
	
    var panelDetail = Ext.create('Ext.panel.Panel', {
    	layout : 'fit',
        region : 'center',
        disabled: false,
	    items : [{ 
	    	xtype: 'uniGroupTabPanel',
	    	id: 'hbs010Tab',
	    	itemId: 'hbs010Tab',
	    	activeGroup: 0,
	    	cls:'human-panel',
	    	collapsible:true,
	    	items: [{
		    	 	defaults:{
// 						xtype:'uniDetailForm',
// 						xtype:'uniGridPanel',
					    disabled:false,
					    border:0,
					    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}}		
// 						margin: '10 10 10 10'
					},
					items:[{
							title:'<t:message code="system.label.human.personalinfocodeupdate" default="인적사항코드등록"/>',
							id: 'tabTitle01',
							itemId: 'tabTitle01',
							subCode:'H006',
							getSubCode: function()	{
								return this.subCode;
							}
							/*,
							uniOpt: {
								useMultipleSorting	: true,			 	
						    	useLiveSearch		: false,			
						    	onLoadSelectFirst	: true,		//체크박스모델은 false로 변경		
						    	dblClickToEdit		: true,			
						    	useGroupSummary		: false,			
								useContextMenu		: false,			
								useRowNumberer		: true,			
								expandLastColumn	: false,				
								useRowContext		: false,	// rink 항목이 있을경우만 true		
						    	filter: {					
									useFilter	: false,			
									autoCreate	: false		
						    	}
							},
	    					store : hbs010ukrs1Store,
							border: true,
							columns: [
								{dataIndex: 'SUB_CODE'				,		width: 100},
								{dataIndex: 'CODE_NAME'				,		width: 300},
								{dataIndex: 'USE_YN'				,		width: 200	, align: 'center'}//,
							]*/
						},
						<%@include file="./hbs010ukrs1.jsp" %>,		// 직위명등록
						<%@include file="./hbs010ukrs2.jsp" %>,		// 직책명등록
						<%@include file="./hbs010ukrs3.jsp" %>,		// 담당업무며응록
						<%@include file="./hbs010ukrs4.jsp" %>,		// 학력코드등록
						<%@include file="./hbs010ukrs5.jsp" %>,		// 졸업구분등록
						<%@include file="./hbs010ukrs6.jsp" %>,		// 입사코드등록
						<%@include file="./hbs010ukrs7.jsp" %>,		// 병역구분등록
						<%@include file="./hbs010ukrs8.jsp" %>,		// 병역군별등록
						<%@include file="./hbs010ukrs9.jsp" %>,		// 병역계급등록
						<%@include file="./hbs010ukrs10.jsp" %>,	// 병역병과등록
						<%@include file="./hbs010ukrs11.jsp" %>,	// 퇴직사유등록
						<%@include file="./hbs010ukrs12.jsp" %>,	// 사원구분
						<%@include file="./hbs010ukrs18.jsp" %>,	// 직렬코드등록
						<%@include file="./hbs010ukrs19.jsp" %>		// 직종코드등록
				    ],		        
					columns: [
						{dataIndex: 'SUB_CODE'				,		width: 100} ,
						{dataIndex: 'CODE_NAME'				,		width: 300} ,
						{dataIndex: 'REF_CODE1'				,		width: 100	, xtype : 'checkcolumn'},
						{dataIndex: 'USE_YN'				,		width: 100	, align: 'center'}//,
					]
	    	 	},{
		    	 	defaults:{
// 						xtype:'uniDetailForm',
//						xtype:'uniGridPanel',
					    disabled:false,
					    border:0,
					    layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}}	
// 						margin: '10 10 10 10'
					},
					items:[{
							title:'<t:message code="system.label.human.salaryinfocodeupdate" default="급여사항코드등록"/>',
							id: 'tabTitle02',
							itemId: 'tabTitle02',
							subCode:'H031',
							getSubCode: function()	{
								return this.subCode;
							},		        
							/*
							uniOpt: {
								useMultipleSorting	: true,			 	
						    	useLiveSearch		: false,			
						    	onLoadSelectFirst	: true,		//체크박스모델은 false로 변경		
						    	dblClickToEdit		: true,			
						    	useGroupSummary		: false,			
								useContextMenu		: false,			
								useRowNumberer		: true,			
								expandLastColumn	: false,				
								useRowContext		: false,	// rink 항목이 있을경우만 true		
						    	filter: {					
									useFilter	: false,			
									autoCreate	: false		
						    	}
							},
    						store : hbs010ukrs13Store,
    						border: true,
							columns: [
								{dataIndex: 'SUB_CODE'				,		width: 100},
								{dataIndex: 'CODE_NAME'				,		width: 300},
								{dataIndex: 'USE_YN'				,		width: 200	, align: 'center'}//,
							]*/
						},
						<%@include file="./hbs010ukrs13.jsp" %>,	// 지급차수등록
						<%@include file="./hbs010ukrs14.jsp" %>,	// 지급구분등록
						<%@include file="./hbs010ukrs15.jsp" %>,	// 기타소득코드등록
						<%@include file="./hbs010ukrs16.jsp" %>,	// 주민세관할관청등록
						<%@include file="./hbs010ukrs17.jsp" %>		// 금융기관코드등록
				    ]
	    		}],
 	    		/*listeners:{	    			
 			    	beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
 			    		if(Ext.isObject(oldCard))	{
 			    			 if(UniAppManager.app._needSave())	{
 			    				if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
 									UniAppManager.app.onSaveDataButtonDown();
 									this.setActiveTab(oldCard);									
 								}else {
 									oldCard.down().getStore().rejectChanges();									
 									UniAppManager.setToolbarButtons('save',false);
 									UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());									
 								}
 			    			 }else {
 			    			 	UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());			    			 	
 			    			 }
 			    		}
 			    	}
 			    }*/
			    listeners:{	    		
			    	beforetabchange : function( grouptabPanel, newCard, oldCard, eOpts )	{
			    		if(Ext.isObject(oldCard))	{
			    			 if(UniAppManager.app._needSave())	{			    				
			    				 Ext.Msg.show({
			    					    title:'<t:message code="system.label.human.confirm" default="확인"/>',
			    					    msg: "<t:message code="system.message.human.message074" default="내용이 변경되었습니다."/>" + "\n" + "<t:message code="system.message.human.message080" default="변경된 내용을 저장하시겠습니까?"/>",
// 			    					    buttons: Ext.Msg.YESNOCANCEL,
										buttons: Ext.Msg.YESNO,
			    					    icon: Ext.Msg.QUESTION,
			    					    fn: function(btn) {
			    					        if (btn === 'yes') {			    					        	
			    					        	oldCard.getStore().saveStore(oldCard);			    					        	
			    					        	UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());			    					        	
			    					        }else if (btn === 'no') {			    					        	
			    					        	UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());			    					        	
			    					        }
// 			    					        else if (btn === 'cancel') {		    					        	
// 			    					        	//grouptabPanel.setActiveTab(oldCard);
// // 			    					        	this.close();
// 												return false;
// 			    					        } 
			    					    }
			    					});			    				 
			    			 }else{/*
			    			 	if (grouptabPanel.activeTab.itemId() == 'tabTitle01')
			    			 	{
			    			 	}*/
			    				UniAppManager.app.loadTabData(newCard, newCard.getItemId(), newCard.getSubCode());
			    			 }
			    		}
			    	}
			    }
			}]
		}
    )
    

	 Unilite.Main( {
		borderItems:[ 
			panelDetail		 	
		], 
		id : 'hbs010ukrApp',
		fnInitBinding : function() {				
			UniAppManager.setToolbarButtons('newData',true);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);			
			
			hbs010ukrs1Store.loadStoreRecords();						
			UniAppManager.app.onQueryButtonDown();	
		},
		loadTabData: function(tab, itemId, mainCode){			
			if(tab.getId() == 'tabTitle01' || tab.getId() == 'hbs010ukrGrid1'){				
				hbs010ukrs1Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid2'){				
				hbs010ukrs2Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid3'){				
				hbs010ukrs3Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid4'){				
				hbs010ukrs4Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid5'){				
				hbs010ukrs5Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid6'){				
				hbs010ukrs6Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid7'){				
				hbs010ukrs7Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid8'){				
				hbs010ukrs8Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid9'){				
				hbs010ukrs9Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid10'){				
				hbs010ukrs10Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid11'){				
				hbs010ukrs11Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid12'){				
				hbs010ukrs12Store.loadStoreRecords();				
			}else if(tab.getId() == 'tabTitle02' || tab.getId() == 'hbs010ukrGrid13'){				
				hbs010ukrs13Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid14'){				
				hbs010ukrs14Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid15'){				
				hbs010ukrs15Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid16'){				
				hbs010ukrs16Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid17'){				
				hbs010ukrs17Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid18'){				
				hbs010ukrs18Store.loadStoreRecords();				
			}else if(tab.getId() == 'hbs010ukrGrid19'){				
				hbs010ukrs19Store.loadStoreRecords();				
			}
			 
		},
		onQueryButtonDown : function()	{			
			var activeTabId = panelDetail.down('#hbs010Tab').getActiveTab().getId();			
			if( activeTabId == 'tabTitle01' || activeTabId == 'hbs010ukrGrid1'){				
				hbs010ukrs1Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid2'){				
				hbs010ukrs2Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid3'){				
				hbs010ukrs3Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid4'){				
				hbs010ukrs4Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid5'){				
				hbs010ukrs5Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid6'){				
				hbs010ukrs6Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid7'){				
				hbs010ukrs7Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid8'){				
				hbs010ukrs8Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid9'){				
				hbs010ukrs9Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid10'){				
				hbs010ukrs10Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid11'){				
				hbs010ukrs11Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid12'){				
				hbs010ukrs12Store.loadStoreRecords();				
			}else if( activeTabId == 'tabTitle02' || activeTabId == 'hbs010ukrGrid13'){				
				hbs010ukrs13Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid14'){				
				hbs010ukrs14Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid15'){				
				hbs010ukrs15Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid16'){				
				hbs010ukrs16Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid17'){				
				hbs010ukrs17Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid18'){				
				hbs010ukrs18Store.loadStoreRecords();				
			}else if(activeTabId == 'hbs010ukrGrid19'){				
				hbs010ukrs19Store.loadStoreRecords();				
			}
			
		},
/*		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},*/
		onNewDataButtonDown : function()	{			
			var activeTab = panelDetail.down('#hbs010Tab').getActiveTab();
			var subCode = activeTab.getSubCode();

			switch(activeTab.getItemId()){
			case 'uniGridPanel0' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel1' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel2' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel3' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel4' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel5' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel6' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel7' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel8' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel9' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel10' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel11' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel12' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel13' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel14' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel15' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel16' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel17' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel18' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			case 'uniGridPanel19' :
				activeTab.createRow({'MAIN_CODE':subCode, 'USE_YN':'Y'});
				break;
			default:
				break;
			}
		},
		onSaveDataButtonDown: function () {			
			var activeTab = panelDetail.down('#hbs010Tab').getActiveTab();
			activeTab.getStore().saveStore(activeTab);
			
		},
		confirmDelete : function(activeTab){						
			var selRow = activeTab.getSelectedRecord();			
			if(selRow.phantom === true)	{
				activeTab.deleteSelectedRow();
			}else{
				Ext.Msg.show({
				    title:'<t:message code="system.label.human.delete" default="삭제"/>',
				    msg: '<t:message code="system.message.human.message032" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>',
				    buttons: Ext.Msg.YESNO,
				    icon: Ext.Msg.QUESTION,
				    fn: function(btn) {
				        if (btn === 'yes') {
				        	activeTab.deleteSelectedRow(selRow);
				        } else if (btn === 'no') {
				            this.close();
				        } 
				    }
				});
			}			
		},
		onDeleteDataButtonDown : function()	{
			var activeTab = panelDetail.down('#hbs010Tab').getActiveTab();
			this.confirmDelete(activeTab);						
		}
	});   
};

</script>
