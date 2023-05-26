<%@page language="java" contentType="text/html; charset=utf-8"%>
	Unilite.defineModel('sbs010ukrvsModel', {
		    fields : [ 	  
		    	  {name : 'MAIN_CODE',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textMainCode','종합코드'),	type : 'string'	, allowBlank : false, readOnly:true}
				, {name : 'SUB_CODE',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textSubCode','상세코드'),	type : 'string'	, allowBlank : false, isPk:true,  pkGen:'user', readOnly:true}
				, {name : 'CODE_NAME',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textCodeName','상세코드명')	, allowBlank : false}
				, {name : 'SYSTEM_CODE_YN',	text : UniUtils.getLabel('system.label.commonJS.codeGrid.textSystemCodeYn','시스템'),	type : 'string',		comboType : 'AU', comboCode : 'B018', defaultValue:'2'}
				, {name : 'SORT_SEQ',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textSortSeq','정렬순서'),	type : 'int',			defaultValue:1	, allowBlank : false}
				, {name : 'REF_CODE1',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode1','관련1'),		type : 'string'	}
				, {name : 'REF_CODE2',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode2','관련2'),		type : 'string'	}
				, {name : 'REF_CODE3',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode3','관련3'),		type : 'string'	}
				, {name : 'REF_CODE4',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode4','관련4'),		type : 'string'	}
				, {name : 'REF_CODE5',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode5','관련5'),		type : 'string'	}
				, {name : 'REF_CODE6',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode6','관련6'),		type : 'string'	}
				, {name : 'REF_CODE7',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode7','관련7'),		type : 'string'	}
				, {name : 'REF_CODE8',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode8','관련8'),		type : 'string'	}
				, {name : 'REF_CODE9',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode9','관련9'),		type : 'string'	}
				, {name : 'REF_CODE10',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode10','관련10'),		type : 'string'	} 
				, {name : 'REF_CODE11',		text : '구매확인서',		type : 'string', comboType : 'AU', comboCode : 'B010' 	}
				, {name : 'REF_CODE12',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode12','관련12'),		type : 'string'	}
				, {name : 'REF_CODE13',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode13','관련13'),		type : 'string'	}
				, {name : 'REF_CODE14',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode14','관련14'),		type : 'string'	}
				, {name : 'REF_CODE15',		text : UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode15','관련15'),		type : 'string'	}
				, {name : 'USE_YN',			text : UniUtils.getLabel('system.label.commonJS.codeGrid.textUserYn','사용여부'),	type : 'string',		defaultValue:'Y'	, allowBlank : false, comboType : 'AU', comboCode : 'B010'} 
				, {name : 'S_COMP_CODE',	text : UniUtils.getLabel('system.label.commonJS.codeGrid.textCompCode','법인코드'),		type : 'string', 	defaultValue: UserInfo.compCode	} 

			]
		});
	var directProxySaleType = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'bsa100ukrvService.selectDetailCodeList',
				create 	: 'bsa100ukrvService.insertCodes',
				update 	: 'bsa100ukrvService.updateCodes',
				destroy	: 'bsa100ukrvService.deleteCodes',
				syncAll	: 'bsa100ukrvService.saveAll'
			}
		});
	var sbs010ukrv1Store = Unilite.createStore('sbs010ukrv1Store',{
		model	: 'sbs010ukrvsModel',
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		proxy: directProxySaleType,
		loadStoreRecords : function(){
			this.load({params:{'MAIN_CODE':'S002'}});
		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords: ", inValidRecs);
			if(inValidRecs.length == 0) {
				this.syncAll();
			} else {
				saleTypeGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				//Unilite.messageBox('<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
			}
		}
	});
	var saleTypeGrid = Unilite.createGrid('sbs010ukrvGrid1', {
		store		: sbs010ukrv1Store,
		itemId		: 'saleTypeGrid',
		subCode		: 'S002',
		uniOpt		: {
			expandLastColumn	: true,
			useRowNumberer		: true,
			useMultipleSorting	: false,
			state: {
				useState: false,			//그리드 설정 버튼 사용 여부
				useStateList: false		//그리드 설정 목록 사용 여부
			}
		},
		bodyCls		: 'human-panel-form-background',
		padding		: '0 0 0 0',
		autoScroll	: true,
		dockedItems	: [{
			xtype	: 'toolbar',
			dock	: 'top',
			padding	: '0px',
			border	: 0
		}],
		columns: [
			{dataIndex : 'MAIN_CODE',		width: 100,	hidden : true},
			{dataIndex : 'SUB_CODE',		width: 100},
			{dataIndex : 'CODE_NAME',		width: 200},
			{dataIndex : 'SYSTEM_CODE_YN',	width: 100},
			{dataIndex : 'REF_CODE11',		width: 110},
			{dataIndex : 'USE_YN',			width: 100}
		],
		getSubCode: function() {
			return this.subCode;
		}
	});
	var saleType = {
		itemId	: 'saleType',
		layout	: {type: 'vbox', align:'stretch'},
		items	: [{
			title		: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			itemId		: 'tab_saleType',
			xtype		: 'container',
			layout		: {type: 'hbox', align:'stretch'},
			flex		: 1,
			autoScroll	: false,
			items		: [{
			
				bodyCls		: 'human-panel-form-background',
				xtype		: 'uniGridPanel',
				itemId		: 'saleTypeGrid',
				store		: sbs010ukrv1Store,
				padding		: '0 0 0 0',
				dockedItems	: [{
					xtype	: 'toolbar',
					dock	: 'top',
					padding	: '0px',
					border	: 0
				}],
				uniOpt:{
					expandLastColumn	: true,
					useRowNumberer		: true,
					useMultipleSorting	: false,
					state: {
						useState: false,			//그리드 설정 버튼 사용 여부
						useStateList: false		//그리드 설정 목록 사용 여부
					}
				},
				columns: [
					{dataIndex : 'MAIN_CODE',		width: 100,	hidden : true},
					{dataIndex : 'SUB_CODE',		width: 100},
					{dataIndex : 'CODE_NAME',		width: 300},
					{dataIndex : 'SYSTEM_CODE_YN',	width: 100},
					{dataIndex : 'REF_CODE11',		width: 110},
					{dataIndex : 'USE_YN',			width: 100}
				],
				getSubCode: function() {
					return this.subCode;
				}
			
			}]
		}]
	}
			