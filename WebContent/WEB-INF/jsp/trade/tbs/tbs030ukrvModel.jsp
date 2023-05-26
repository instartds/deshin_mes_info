<%@page language="java" contentType="text/html; charset=utf-8"%>
	/** Model 정의 
	* @type 
	*/
	//tbs030ukrvs1 Model
	Unilite.defineModel('tbs030ukrvs1Model', {
		fields: [
			{name: 'COMP_CODE'		,text:'<t:message code="system.label.trade.companycode" default="법인코드"/>'				,type:'string'},
			{name: 'TRADE_DIV'		,text:'<t:message code="system.label.trade.tradeclass" default="무역구분"/>'				,type:'string',	comboType: 'AU',comboCode:'T001'},
			{name: 'CHARGE_TYPE1'	,text:'진행구분'		,type:'string',		comboType: 'AU',comboCode:'T070'},
			{name: 'CHARGE_TYPE2'	,text:'진행구분'		,type:'string',		comboType: 'AU',comboCode:'T071'},
			{name: 'CHARGE_TYPENM'	,text:'진행구분명'		,type:'string'},
			{name: 'CHARGE_CODE'	,text:'<t:message code="system.label.trade.expensecode" default="경비코드"/>'				,type:'string'},
			{name: 'CHARGE_NAME'	,text:'<t:message code="system.label.trade.expensename" default="경비명"/>'				,type:'string'},
			{name: 'COST_DIV'		,text:'<t:message code="system.label.trade.expensedistributionyn" default="부대비배부여부"/>'	,type:'string',		comboType: 'AU',comboCode:'T105'},
			{name: 'TAX_DIV'		,text:'부가세기표여부'		,type:'string',		comboType: 'AU',comboCode:'B010'},
			{name: 'INSERT_DB_USER'	,text:'수정자'			,type:'string',		defaultValue:UserInfo.userName, editable:false},	// editable:false 수정불가
			{name: 'INSERT_DB_TIME'	,text:'수정일'			,type:'uniDate',	editable:false, defaultValue:UniDate.today()},
			{name: 'UPDATE_DB_USER'	,text:'수정자'			,type:'string',		defaultValue:UserInfo.userName, editable:false},
			{name: 'UPDATE_DB_TIME'	,text:'수정일'			,type:'uniDate',	editable:false, defaultValue:UniDate.today()}
		]
	});
	//tbs030ukrvs1 store
	var tbs030ukrvs1Store = Unilite.createStore('tbs030ukrvs1Store',{
		model	: 'tbs030ukrvs1Model',
		proxy	: directProxy1,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function(){
			var param = panelDetail.down('#tbs030ukrvs1Tab').getValues();
			this.load({
				params: param
			});
		}
	});



	//tbs030ukrvs2 Model
	Unilite.defineModel('tbs030ukrvs2Model', {
		fields: [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.trade.companycode" default="법인코드"/>'	,type:'string'},
			//20191204 수정: HS번호, HS명, HS단위 필수 처리
			{name: 'HS_NO'			,text: 'H.S 번호'		,type: 'string'		, allowBlank: false},
			{name: 'HS_NAME'		,text: 'H.S 명'		,type: 'string'		, allowBlank: false},
			{name: 'HS_SPEC'		,text: 'H.S 규격'		,type: 'string'},
			{name: 'HS_UNIT'		,text: 'H.S 단위'		,type: 'string'		, allowBlank: false, comboType: 'AU',comboCode:'B013', displayField: 'value'},
			{name: 'INSERT_DB_USER'	,text: '수정자'		,type: 'string'		, defaultValue:UserInfo.userName, editable:false}, // editable:false 수정불가
			{name: 'INSERT_DB_TIME'	,text: '수정일'		,type: 'uniDate'	, editable:false, defaultValue:UniDate.today()},
			{name: 'UPDATE_DB_USER'	,text: '수정자'		,type: 'string'		, defaultValue:UserInfo.userName, editable:false},
			{name: 'UPDATE_DB_TIME'	,text: '수정일'		,type: 'uniDate'	, editable:false, defaultValue:UniDate.today()}
		]
	});	
	//tbs030ukrvs2 store
	var tbs030ukrvs2Store = Unilite.createStore('tbs030ukrvs2Store',{
		model	: 'tbs030ukrvs2Model',
		proxy	: directProxy2,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function(){
			var param =  panelDetail.down('#tbs030ukrvs2Tab').getValues();
			this.load({
				params: param
			});
		},
		saveStore: function() {
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();
			var toDelete	= this.getRemovedRecords();
			var list		= [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0) {
				config = {
					success: function(batch, option) {
						UniAppManager.setToolbarButtons('save', false);

						UniAppManager.app.onQueryButtonDown();

						if(tbs030ukrvs2Store.getCount() == 0) {
							UniAppManager.app.onResetButtonDown();
						}
					}
				};
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('tbs030ukrvs2Grid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});



	//tbs030ukrvs3 Model
	Unilite.defineModel('tbs030ukrvs3Model', {
		fields: [
			{name: 'COMP_CODE'		,text: '<t:message code="system.label.trade.companycode" default="법인코드"/>'		,type:'string'},
			{name: 'CHOICE'			,text: '선택'			,type: 'string'},
			{name: 'ITEM_CODE'		,text: '<t:message code="system.label.trade.itemcode" default="품목코드"/>'			,type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.trade.itemname" default="품목명"/>'			,type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.trade.spec" default="규격"/>'				,type: 'string'},
			{name: 'HS_NO'			,text: 'H.S번호'		,type: 'string'},
			{name: 'HS_NAME'		,text: 'H.S명'		,type: 'string'},
			{name: 'HS_UNIT'		,text: 'H.S단위'		,type: 'string'},
			{name: 'INSERT_DB_USER'	,text: '수정자'		,type: 'string'		, defaultValue:UserInfo.userName, editable:false}, // editable:false 수정불가
			{name: 'INSERT_DB_TIME'	,text: '수정일'		,type: 'uniDate'	, editable:false, defaultValue:UniDate.today()},
			// hidden
			{name: 'SPEC_TEMP'		,text: '<t:message code="system.label.trade.spec" default="규격"/>'				,type: 'string'},
			{name: 'HS_NO_TEMP'		,text: 'H.S번호'		,type: 'string'},
			{name: 'HS_NAME_TEMP'	,text: 'H.S명'		,type: 'string'},
			{name: 'HS_UNIT_TEMP'	,text: 'H.S단위'		,type: 'string'}
		]
	});

	//tbs030ukrvs3 store
	var tbs030ukrvs3Store = Unilite.createStore('tbs030ukrvs3Store',{
		model	: 'tbs030ukrvs3Model',
		proxy	: directProxy3,
		uniOpt	: {
			isMaster	: true,		// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,		// 삭제 가능 여부 
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function(){
			var param =  panelDetail.down('#tbs030ukrvs3Tab').getValues();
			this.load({
				params: param
			});
		},
		saveStore : function() {
			var inValidRecs = this.getInvalidRecords();
			var rv = true;
			if(inValidRecs.length == 0 ) {
				this.syncAllDirect();
			} else {
				panelDetail.down('#tbs030ukrvs3Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});