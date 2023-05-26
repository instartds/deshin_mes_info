<%@page language="java" contentType="text/html; charset=utf-8"%>
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read	: 'bsa100ukrvService.selectDetailSales',
				create	: 'bsa100ukrvService.insertCodes',
				update	: 'bsa100ukrvService.updateCodes',
				destroy	: 'bsa100ukrvService.deleteCodes',
				syncAll	: 'bsa100ukrvService.saveAll'
			}
	});

	var systemYNStore = Unilite.createStore('sbs010ukrvsYNStore', {
		fields	: ['text', 'value'],
		data	: [
			{'text':'<t:message code="system.label.sales.yes" default="예"/>'	, 'value':'1'},
			{'text':'<t:message code="system.label.sales.no" default="아니오"/>'	, 'value':'2'}
		]
	});

	Unilite.defineModel('sbs010ukrvs_4Model', {
		fields: [
			{name: 'MAIN_CODE'		,text:'<t:message code="system.label.sales.maincode" default="메인코드"/>'				,type : 'string' , allowBlank : false, readOnly:true},
			{name: 'SUB_CODE'		,text:'<t:message code="system.label.sales.subcode" default="상세코드"/>'				,type : 'string' , allowBlank : false, isPk:true,  pkGen:'user', readOnly:true},
			{name: 'CODE_NAME'		,text:'<t:message code="system.label.sales.subcodename" default="상세코드명"/>'			,type : 'string' , allowBlank : false},
			{name: 'CODE_NAME_EN'	,text:'<t:message code="system.label.sales.subcodenameen" default="상세코드명(영어)"/>'	,type : 'string'},
			{name: 'CODE_NAME_JP'	,text:'<t:message code="system.label.sales.subcodenamejp" default="상세코드명(일본어)"/>'	,type : 'string'},
			{name: 'CODE_NAME_CN'	,text:'<t:message code="system.label.sales.subcodenamecn" default="상세코드명(중국어)"/>'	,type : 'string'},
			{name: 'REF_CODE1'		,text:'<t:message code="system.label.sales.division" default="사업장"/>'				,type : 'string' , allowBlank : false , comboType:'BOR120'},
			{name: 'REF_CODE2'		,text:'<t:message code="system.label.sales.department" default="부서"/>'				,type : 'string' },
			{name: 'DEPT_NAME'		,text:'<t:message code="system.label.sales.department" default="부서"/>'				,type : 'string' , allowBlank : false},
			{name: 'REF_CODE3'		,text:'<t:message code="system.label.sales.applyys" default="적용여부"/>'				,type : 'string'},
			{name: 'REF_CODE4'		,text:'<t:message code="system.label.sales.approvaluser" default="승인자"/>ID'			,type : 'string'},	// ID
			{name: 'USER_NAME'		,text:'<t:message code="system.label.sales.approvalusername" default="승인자명"/>'		,type : 'string'},
			{name: 'REF_CODE5'		,text:'<t:message code="system.label.sales.connectuserid" default="접속자ID"/>'		,type : 'string'},	// ID
			{name: 'USER_NAME2'		,text:'<t:message code="system.label.sales.connectusername" default="접속자명"/>'		,type : 'string'},
			{name: 'REF_CODE6'		,text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>'				,type : 'string'},
			{name: 'REF_CODE7'		,text:'E-Mail'		,type : 'string'},
			{name: 'REF_CODE8'		,text:'<t:message code="system.label.sales.personnumb" default="사번"/>'				,type : 'string'},
			{name: 'REF_CODE9'		,text:'<t:message code="system.label.sales.refcode9" default="참조코드9"/>'				,type : 'string'},
			{name: 'REF_CODE10'		,text:'<t:message code="system.label.sales.refcode10" default="참조코드10"/>'			,type : 'string'},
			{name: 'SUB_LENGTH'		,text:''			,type : 'int'},
			{name: 'USE_YN'			,text:'<t:message code="system.label.sales.useyn" default="사용여부"/>'					,type : 'string' , defaultValue:'Y'	, allowBlank : false, comboType : 'AU', comboCode : 'B010'},
			{name: 'SORT_SEQ'		,text:'<t:message code="system.label.sales.arrangeorder" default="정렬순서"/>'			,type : 'int'	 , defaultValue:1	, allowBlank : false},
			{name: 'SYSTEM_CODE_YN'	,text:'<t:message code="system.label.sales.system" default="시스템"/>'					,type : 'string' , store: Ext.data.StoreManager.lookup('sbs010ukrvsYNStore') , defaultValue:'2'},
			{name: 'UPDATE_DB_USER'	,text:''			,type : 'string'},
			{name: 'UPDATE_DB_TIME'	,text:''			,type : 'string'},
			{name :'S_COMP_CODE'	,text:''			,type : 'string' , defaultValue: UserInfo.compCode	} 
		]
	});
	
	var sbs010ukrvs_4Store = Unilite.createStore('sbs010ukrvs_4Store',{
		model	: 'sbs010ukrvs_4Model',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			var rv = true;
			if(inValidRecs.length == 0 ) {
				this.syncAllDirect();
			} else {
				panelDetail.down('#sbs010ukrvs_4Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords : function(){
			this.load();
		}
	});

	var sales = {
		//title:'영업/수금담당',
		itemId	: 'sales',
		layout	: {type: 'vbox', align:'stretch'},
		items	: [{
			title		: '<t:message code="system.label.sales.salescollectioncharge" default="영업/수금담당"/>',
			itemId		: 'tab_sales',
			xtype		: 'container',
			layout		: {type: 'hbox', align:'stretch'},
			flex		: 1,
			autoScroll	: false,
			items		: [{
				bodyCls		: 'human-panel-form-background',
				xtype		: 'uniGridPanel',
				itemId		: 'sbs010ukrvs_4Grid',
				store		: sbs010ukrvs_4Store,
				padding		: '0 0 0 0',
				dockedItems	: [{
					xtype	: 'toolbar',
					dock	: 'top',
					padding	: '0px',
					border	: 0
				}],
				uniOpt:{
					expandLastColumn	: false,
					useRowNumberer		: true,
					useMultipleSorting	: false
				},
				columns: [
					{dataIndex: 'MAIN_CODE'			, width: 100, hidden: true},
					{dataIndex: 'SUB_CODE'			, width: 100},
					{dataIndex: 'CODE_NAME'			, flex: 1	},
					{dataIndex: 'CODE_NAME_EN'		, width: 133, hidden: true},
					{dataIndex: 'CODE_NAME_CN'		, width: 133, hidden: true},
					{dataIndex: 'CODE_NAME_JP'		, width: 133, hidden: true},
					{dataIndex: 'SYSTEM_CODE_YN'	, width: 100},
					{dataIndex: 'REF_CODE1'			, width: 100},
					{dataIndex: 'REF_CODE2'			, width: 100 , hidden: true},
					{dataIndex: 'REF_CODE3'			, width: 100, hidden: true},
					{dataIndex: 'DEPT_NAME'			, width: 200 ,
						'editor': Unilite.popup('DEPT_G',{
							textFieldName	: 'DEPT_NAME',
							autoPopup		: true,
							listeners		: {
								'onSelected': {
									fn: function(records, type){
									var grdRecord = panelDetail.down('#sbs010ukrvs_4Grid').uniOpt.currentRecord;
									grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
									grdRecord.set('REF_CODE2',records[0]['TREE_CODE']);
									
									},
									scope: this
								},
								'onClear' : function(type) {
									var grdRecord = panelDetail.down('#sbs010ukrvs_4Grid').uniOpt.currentRecord;
									grdRecord.set('DEPT_NAME','');
									grdRecord.set('REF_CODE2','');
								}
							}
						})
					},
					{dataIndex: 'REF_CODE4'			, width: 100, hidden: true},
					// 승인자 명 //
					{dataIndex: 'USER_NAME'			, width: 100 ,
						'editor': Unilite.popup('USER_G',{
							textFieldName	: 'USER_NAME',
							autoPopup		: true,
							listeners		: {
								'onSelected': {
									fn: function(records, type  ){
										var grdRecord = panelDetail.down('#sbs010ukrvs_4Grid').uniOpt.currentRecord;
										grdRecord.set('USER_NAME',records[0]['USER_NAME']);
										grdRecord.set('REF_CODE4',records[0]['USER_ID']);
									},
									scope: this
								},
								'onClear': function(type) {
									var grdRecord = panelDetail.down('#sbs010ukrvs_4Grid').uniOpt.currentRecord;
									grdRecord.set('USER_NAME','');
									grdRecord.set('REF_CODE4','');
								}
							}
						})
					},
					// 사용자 ID //
					{dataIndex: 'REF_CODE5'			, width: 100 ,
						'editor': Unilite.popup('USER_G',{
							textFieldName	: 'USER_NAME',
							autoPopup		: true,
							listeners		: {
								'onSelected': {
									fn: function(records, type){
										var grdRecord = panelDetail.down('#sbs010ukrvs_4Grid').uniOpt.currentRecord;
										grdRecord.set('USER_NAME2',records[0]['USER_NAME']);
										grdRecord.set('REF_CODE5',records[0]['USER_ID']);
									},
									scope: this
								},
								'onClear' : function(type) {
									var grdRecord = panelDetail.down('#sbs010ukrvs_4Grid').uniOpt.currentRecord;
									grdRecord.set('USER_NAME2','');
									grdRecord.set('REF_CODE5','');
								}
							}
						})
					},
					// 접속자 명 //
					{dataIndex: 'USER_NAME2'		, width: 100 ,
						'editor': Unilite.popup('USER_G',{
							textFieldName : 'USER_NAME',
							autoPopup: true,
							listeners: {
								'onSelected': {
									fn: function(records, type  ){
										var grdRecord = panelDetail.down('#sbs010ukrvs_4Grid').uniOpt.currentRecord;
										grdRecord.set('USER_NAME2',records[0]['USER_NAME']);
										grdRecord.set('REF_CODE5',records[0]['USER_ID']);
									},
									scope: this
								},
								'onClear' : function(type) {
									var grdRecord = panelDetail.down('#sbs010ukrvs_4Grid').uniOpt.currentRecord;
									grdRecord.set('USER_NAME2','');
									grdRecord.set('REF_CODE5','');
								}
							}
						})
					},
					{dataIndex: 'REF_CODE6'			, width: 100, hidden: true},
					{dataIndex: 'REF_CODE7'			, width: 133, hidden: true},
					{dataIndex: 'REF_CODE8'			, width: 100, hidden: true},
					{dataIndex: 'REF_CODE9'			, width: 100, hidden: true},
					{dataIndex: 'REF_CODE10'		, width: 100, hidden: true},
					{dataIndex: 'SUB_LENGTH'		, width: 66	, hidden: true},
					{dataIndex: 'USE_YN'			, width: 100},
					{dataIndex: 'SORT_SEQ'			, width: 66, hidden: true},
					{dataIndex: 'UPDATE_DB_USER'	, width: 66, hidden: true},
					{dataIndex: 'UPDATE_DB_TIME'	, width: 66, hidden: true},
					{dataIndex: 'S_COMP_CODE'		, width: 66, hidden: true}
				],
				getSubCode: function() {
					return this.subCode;
				}
			}]
		}]
	}