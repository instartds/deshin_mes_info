//@charset UTF-8
Ext.define('Unilite.com.config.CodeGrid', {
	extend		: 'Ext.container.Container',
	alias		: 'widget.ConfigCodeGrid',
	codeName	: '',
	subCode		: '',
	constructor	: function(config){
		var me	= this;
		var grid= me.sysCodeGridConfig( config.codeName, config.subCode, config.proxy, config.showRefCodes )	;
		//Ext.apply(config, mConfig);
		
		if (config) {
			Ext.apply(me, config);
		};
		this.items=[grid];
		this.callParent([config]);
	},
	initComponent: function() {
		var me = this;
		me.callParent(arguments);
	},
	sysCodeGridConfig:function(codeName, subCode , proxy, showRefCodes) {
		Unilite.defineModel('systemCodeModel'+subCode, {
			fields : [	 
				{name: 'MAIN_CODE',			text: UniUtils.getLabel('system.label.commonJS.codeGrid.textMainCode','종합코드')		, allowBlank : false, readOnly:true},
				{name: 'SUB_CODE',			text: UniUtils.getLabel('system.label.commonJS.codeGrid.textSubCode','상세코드')		, allowBlank : false, isPk:true, pkGen:'user', readOnly:true},
				{name: 'CODE_NAME',			text: UniUtils.getLabel('system.label.commonJS.codeGrid.textCodeName','상세코드명')		, allowBlank : false},
				{name: 'SYSTEM_CODE_YN',	text: UniUtils.getLabel('system.label.commonJS.codeGrid.textSystemCodeYn','시스템')	, type : 'string'	, comboType : 'AU', comboCode : 'B018', defaultValue:'2'},
				{name: 'SORT_SEQ',			text: UniUtils.getLabel('system.label.commonJS.codeGrid.textSortSeq','정렬순서')		, type : 'int'		, defaultValue:1	, allowBlank : false},
				{name: 'REF_CODE1',			text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode1','관련1')		, type : 'string'},
				{name: 'REF_CODE2',			text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode2','관련2')		, type : 'string'},
				{name: 'REF_CODE3',			text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode3','관련3')		, type : 'string'},
				{name: 'REF_CODE4',			text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode4','관련4')		, type : 'string'},
				{name: 'REF_CODE5',			text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode5','관련5')		, type : 'string'},
				{name: 'REF_CODE6',			text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode6','관련6')		, type : 'string'},
				{name: 'REF_CODE7',			text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode7','관련7')		, type : 'string'},
				{name: 'REF_CODE8',			text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode8','관련8')		, type : 'string'},
				{name: 'REF_CODE9',			text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode9','관련9')		, type : 'string'},
				{name: 'REF_CODE10',		text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode10','관련10')		, type : 'string'},
				{name: 'REF_CODE11',		text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode11','관련11')		, type : 'string'},
				{name: 'REF_CODE12',		text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode12','관련12')		, type : 'string'},
				{name: 'REF_CODE13',		text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode13','관련13')		, type : 'string'},
				{name: 'REF_CODE14',		text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode14','관련14')		, type : 'string'},
				{name: 'REF_CODE15',		text: UniUtils.getLabel('system.label.commonJS.codeGrid.textRefCode15','관련15')		, type : 'string'},
				{name: 'USE_YN',			text: UniUtils.getLabel('system.label.commonJS.codeGrid.textUserYn','사용여부')			, type : 'string', defaultValue:'Y'	, allowBlank : false, comboType : 'AU', comboCode : 'B010'}, 
				{name: 'S_COMP_CODE',		text: UniUtils.getLabel('system.label.commonJS.codeGrid.textCompCode','법인코드')		, type : 'string', defaultValue: UserInfo.compCode},
				{name: 'REF_CODE1_LABLE',	text: '관련코드1 라벨'	, type : 'string'},
				{name: 'REF_CODE2_LABLE',	text: '관련코드2 라벨'	, type : 'string'},
				{name: 'REF_CODE3_LABLE',	text: '관련코드3 라벨'	, type : 'string'},
				{name: 'REF_CODE4_LABLE',	text: '관련코드4 라벨'	, type : 'string'},
				{name: 'REF_CODE5_LABLE',	text: '관련코드5 라벨'	, type : 'string'},
				{name: 'REF_CODE6_LABLE',	text: '관련코드6 라벨'	, type : 'string'},
				{name: 'REF_CODE7_LABLE',	text: '관련코드7 라벨'	, type : 'string'},
				{name: 'REF_CODE8_LABLE',	text: '관련코드8 라벨'	, type : 'string'},
				{name: 'REF_CODE9_LABLE',	text: '관련코드9 라벨'	, type : 'string'},
				{name: 'REF_CODE10_LABLE',	text: '관련코드10 라벨'	, type : 'string'},
				{name: 'REF_CODE11_LABLE',	text: '관련코드11 라벨'	, type : 'string'},
				{name: 'REF_CODE12_LABLE',	text: '관련코드12 라벨'	, type : 'string'},
				{name: 'REF_CODE13_LABLE',	text: '관련코드13 라벨'	, type : 'string'},
				{name: 'REF_CODE14_LABLE',	text: '관련코드14 라벨'	, type : 'string'},
				{name: 'REF_CODE15_LABLE',	text: '관련코드15 라벨'	, type : 'string'}
			]
		});

		var grid;
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read	: 'bsa100ukrvService.selectDetailCodeList',
				create	: 'bsa100ukrvService.insertCodes',
				update	: 'bsa100ukrvService.updateCodes',
				destroy	: 'bsa100ukrvService.deleteCodes',
				syncAll	: 'bsa100ukrvService.saveAll'
			}
		});

		var inStore = Ext.create('Unilite.com.data.UniStore', {
			model	: 'systemCodeModel'+subCode,
			autoLoad: false,
			uniOpt	: {
				isMaster	: true,			// 상위 버튼 연결 
				editable	: true,			// 수정 모드 사용 
				deletable	: true,			// 삭제 가능 여부 
				useNavi		: false			// prev | next 버튼 사용
			},
			proxy: Ext.isEmpty(proxy) ? directProxy:proxy,
//			proxy: {
//				type: 'direct',
//				api	: {
//					read : bsa100ukrvService.selectDetailCodeList,
//					update: bsa100ukrvService.updateCodes,
//					create: bsa100ukrvService.insertCodes,
//					destroy:bsa100ukrvService.deleteCodes,
//					syncAll:bsa100ukrvService.syncAll
//				}
//			},
			saveStore : function() {
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 ) {
					this.syncAllDirect();
				}else {
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners:{
				load : function (store, records) {
					var mGrid = grid;
					if(records && records.length > 0) {
						var record = records[0];
						for(var i =1; i<16; i++) {
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

		grid= Unilite.createGrid('', {
			title		: codeName,
			subCode		: subCode,
			flex		: 1,
			dockedItems	: [{
				xtype	: 'toolbar',
				dock	: 'top',
				padding	: '0px',
				border	: 0
			}],
			bodyCls		: 'human-panel-form-background',
			padding		: '0 0 0 0',
			store		: inStore,
			uniOpt		: {
				expandLastColumn	: false,
				useRowNumberer		: true,
				useMultipleSorting	: false
			},
			showRefCodes: showRefCodes,
			columns		: [
				{dataIndex: 'MAIN_CODE',		width: 100,	hidden: true},
				{dataIndex: 'SUB_CODE',			width: 100},
				{dataIndex: 'CODE_NAME',		flex: 1},
				{dataIndex: 'SORT_SEQ',			width: 100,	hidden: true},
				{dataIndex: 'REF_CODE1',		width: 110,	hidden: true},
				{dataIndex: 'REF_CODE2',		width: 110,	hidden: true},
				{dataIndex: 'REF_CODE3',		width: 110,	hidden: true},
				{dataIndex: 'REF_CODE4',		width: 110,	hidden: true},
				{dataIndex: 'REF_CODE5',		width: 110,	hidden: true},
				{dataIndex: 'REF_CODE6',		width: 110,	hidden: true},
				{dataIndex: 'REF_CODE7',		width: 110,	hidden: true},
				{dataIndex: 'REF_CODE8',		width: 110,	hidden: true},
				{dataIndex: 'REF_CODE9',		width: 110,	hidden: true},
				{dataIndex: 'REF_CODE10',		width: 110,	hidden: true},
				{dataIndex: 'REF_CODE11',		width: 110,	hidden: true},
				{dataIndex: 'REF_CODE12',		width: 110,	hidden: true},
				{dataIndex: 'REF_CODE13',		width: 110,	hidden: true},
				{dataIndex: 'REF_CODE14',		width: 110,	hidden: true},
				{dataIndex: 'REF_CODE15',		width: 110,	hidden: true},
				{dataIndex: 'SYSTEM_CODE_YN',	width: 100},
				{dataIndex: 'USE_YN',			width: 100}
			],
			getSubCode: function() {
				return this.subCode;
			},
			listeners:{
				render: function(grid) {
					if(grid.showRefCodes) {
						Ext.each(showRefCodes, function(refCode, i) {
							grid.getColumn(refCode).show();
						});
					}
				}
			}
		});
		return grid;
	}
});