<%@page language="java" contentType="text/html; charset=utf-8"%>
	var multiCompCodeProxy5;
	<c:if test="${multiCompCode == 'true'}">
	multiCompCodeProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bsa101ukrvService.selectDetailCodeList',
			create	: 'bsa101ukrvService.insertCodes',
			update	: 'bsa101ukrvService.updateCodes',
			destroy	: 'bsa101ukrvService.deleteCodes',
			syncAll	: 'bsa101ukrvService.saveAll'
		}
	});
	</c:if>
	var seb100ukrvProxy5 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bsa100ukrvService.selectDetailCodeList',
			create	: 'bsa100ukrvService.insertCodes',
			update	: 'bsa100ukrvService.updateCodes',
			destroy	: 'bsa100ukrvService.deleteCodes',
			syncAll	: 'bsa100ukrvService.saveAll'
		}
	});

	Unilite.defineModel('seb100ukrvsModel5', {
		fields: [
			{name: 'MAIN_CODE'			, text: '<t:message code="system.label.base.maincode" default="메인코드"/>'				, type: 'string'	, allowBlank: false, readOnly: true},
			{name: 'SUB_CODE'			, text: '<t:message code="system.label.sales.subcode" default="상세코드"/>'				, type: 'string'	, allowBlank: false, isPk: true, pkGen: 'user', readOnly: true},
			{name: 'CODE_NAME'			, text: '<t:message code="system.label.sales.subcodename" default="상세코드명"/>'		, type: 'string'	, allowBlank: false},
			{name: 'CODE_NAME_EN'		, text: '<t:message code="system.label.base.codename(en)" default="코드명(영어)"/>'		, type: 'string'},
			{name: 'CODE_NAME_JP'		, text: '<t:message code="system.label.base.codename(jp)" default="코드명(일본어)"/>'		, type: 'string'},
			{name: 'CODE_NAME_CN'		, text: '<t:message code="system.label.base.codename(cn)" default="코드명(중국어)"/>'		, type: 'string'},
			{name: 'CODE_NAME_VI'		, text: '<t:message code="system.label.base.codename(vi)" default="코드명(베트남어)"/>'	, type: 'string'},
			{name: 'REF_CODE1'			, text: '김천사업장'		, type: 'float', decimalPrecision: 0, format:'0,000'},							//20210702 수정: 숫자필드로 변경
			{name: 'REF_CODE2'			, text: '화성사업장'		, type: 'float', decimalPrecision: 0, format:'0,000'},							//20210702 수정: 숫자필드로 변경
			{name: 'REF_CODE3'			, text: '<t:message code="system.label.base.reference" default="참조"/>3'				, type: 'string'},
			{name: 'REF_CODE4'			, text: '<t:message code="system.label.base.reference" default="참조"/>4'				, type: 'string'},
			{name: 'REF_CODE5'			, text: '<t:message code="system.label.base.reference" default="참조"/>5'				, type: 'string'},
			{name: 'REF_CODE6'			, text: '<t:message code="system.label.base.reference" default="참조"/>6'				, type: 'string'},
			{name: 'REF_CODE7'			, text: '<t:message code="system.label.base.reference" default="참조"/>7'				, type: 'string'},
			{name: 'REF_CODE8'			, text: '<t:message code="system.label.base.reference" default="참조"/>8'				, type: 'string'},
			{name: 'REF_CODE9'			, text: '<t:message code="system.label.base.reference" default="참조"/>9'				, type: 'string'},
			{name: 'REF_CODE10'			, text: '<t:message code="system.label.base.reference" default="참조"/>10'			, type: 'string'},
			{name: 'REF_CODE11'			, text: '<t:message code="system.label.base.reference" default="참조"/>11'			, type: 'string'},
			{name: 'REF_CODE12'			, text: '<t:message code="system.label.base.reference" default="참조"/>12'			, type: 'string'},
			{name: 'REF_CODE13'			, text: '<t:message code="system.label.base.reference" default="참조"/>13'			, type: 'string'},
			{name: 'REF_CODE14'			, text: '<t:message code="system.label.base.reference" default="참조"/>14'			, type: 'string'},
			{name: 'REF_CODE15'			, text: '<t:message code="system.label.base.reference" default="참조"/>15'			, type: 'string'},
			{name: 'SUB_LENGTH'			, text: ''			, type : 'int'},
			{name: 'USE_YN'				, text: '<t:message code="system.label.base.useyn" default="사용여부"/>'				, type: 'string'	, allowBlank: false, comboType: 'AU', comboCode: 'B010', defaultValue: 'Y'},
			{name: 'SORT_SEQ'			, text: ''			, type : 'int'		, allowBlank: false, defaultValue: 1},
			{name: 'SYSTEM_CODE_YN'		, text: '<t:message code="system.label.sales.system" default="시스템"/>'				, type : 'string'	, comboType: 'AU', comboCode: 'B018', defaultValue: '2'},
			{name: 'UPDATE_DB_USER'		, text: ''			, type : 'string'},
			{name: 'UPDATE_DB_TIME'		, text: ''			, type : 'string'},
			{name: 'S_COMP_CODE'		, text: ''			, type: 'string', defaultValue: UserInfo.compCode},
			{name: 'REF_CODE1_LABEL'	, text: '관련코드1라벨'	, type: 'string'},
			{name: 'REF_CODE2_LABEL'	, text: '관련코드2라벨'	, type: 'string'},
			{name: 'REF_CODE3_LABEL'	, text: '관련코드3라벨'	, type: 'string'},
			{name: 'REF_CODE4_LABEL'	, text: '관련코드4라벨'	, type: 'string'},
			{name: 'REF_CODE5_LABEL'	, text: '관련코드5라벨'	, type: 'string'},
			{name: 'REF_CODE6_LABEL'	, text: '관련코드6라벨'	, type: 'string'},
			{name: 'REF_CODE7_LABEL'	, text: '관련코드7라벨'	, type: 'string'},
			{name: 'REF_CODE8_LABEL'	, text: '관련코드8라벨'	, type: 'string'},
			{name: 'REF_CODE9_LABEL'	, text: '관련코드9라벨'	, type: 'string'},
			{name: 'REF_CODE10_LABEL'	, text: '관련코드10라벨'	, type: 'string'},
			{name: 'REF_CODE11_LABEL'	, text: '관련코드11라벨'	, type: 'string'},
			{name: 'REF_CODE12_LABEL'	, text: '관련코드12라벨'	, type: 'string'},
			{name: 'REF_CODE13_LABEL'	, text: '관련코드13라벨'	, type: 'string'},
			{name: 'REF_CODE14_LABEL'	, text: '관련코드14라벨'	, type: 'string'},
			{name: 'REF_CODE15_LABEL'	, text: '관련코드15라벨'	, type: 'string'}
		]
	});

	var seb100ukrvStore5 = Unilite.createStore('seb100ukrvStore5',{
		model	: 'seb100ukrvsModel5',
		proxy	: Ext.isEmpty(multiCompCodeProxy5) ? seb100ukrvProxy5:multiCompCodeProxy5,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | next 버튼 사용
		},
		loadStoreRecords : function(){
			var param = {
				'MAIN_CODE': 'SE05'
			}
			this.load({
				params	: param,
				callback: function(records,options,success) {
					if(success) {
					}
				}
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0) {
				this.syncAllDirect();
			}else {
				panelDetail.down('#standardCostPrice').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function (store, records) {
				if(records && records.length > 0) {
					var mGrid	= panelDetail.down('#seb100ukrvGrid5');
					var record	= records[0];

					for(var i = 1; i<16; i++) {
						var d = record.get('REF_CODE'+i+'_LABEL');
						if(!Ext.isEmpty(d)) {
							var column = mGrid.getColumn('REF_CODE'+i);
							column.setText(d);
						}
					}
				}
			}
		}
	});

	var standardCostPrice = {
		itemId	: 'standardCostPrice',
		layout	: {type: 'vbox', align:'stretch'},
		items	: [{
			title		: '표준원가정보',
			itemId		: 'tab_standardCostPrice',
			xtype		: 'container',
			layout		: {type: 'hbox', align:'stretch'},
			flex		: 1,
 			autoScroll	: false,
			items		: [{
				bodyCls		: 'human-panel-form-background',
				xtype		: 'uniGridPanel',
				itemId		: 'seb100ukrvGrid5',
				store		: seb100ukrvStore5,
				autoScroll	: false,
				dockedItems	: [{
					xtype	: 'toolbar',
					dock	: 'top',
					padding	: '0px',
					border	: 0
				}],
				uniOpt		: {
					expandLastColumn	: false,
					useRowNumberer		: true,
					useMultipleSorting	: false
				},
				columns: [
					{dataIndex : 'MAIN_CODE'		, width: 100	, hidden: true},
					{dataIndex : 'SUB_CODE'			, width: 100},
					{dataIndex : 'CODE_NAME'		, flex: 6},
					{dataIndex : 'SORT_SEQ'			, width: 100	, hidden: true},
					{dataIndex : 'REF_CODE1'		, flex: 2		, align: 'center'},
					{dataIndex : 'REF_CODE2'		, flex: 2		, align: 'center'},
					{dataIndex : 'REF_CODE3'		, width: 110	, hidden: true},
					{dataIndex : 'REF_CODE4'		, width: 110	, hidden: true},
					{dataIndex : 'REF_CODE5'		, width: 110	, hidden: true},
					{dataIndex : 'REF_CODE6'		, width: 110	, hidden: true},
					{dataIndex : 'REF_CODE7'		, width: 110	, hidden: true},
					{dataIndex : 'REF_CODE8'		, width: 110	, hidden: true},
					{dataIndex : 'REF_CODE9'		, width: 110	, hidden: true},
					{dataIndex : 'REF_CODE10'		, width: 110	, hidden: true},
					{dataIndex : 'SYSTEM_CODE_YN'	, width: 100},
					{dataIndex : 'USE_YN'			, width: 100}
				],
				getSubCode: function() {
					return this.subCode;
				}
			}]
		}]
	}