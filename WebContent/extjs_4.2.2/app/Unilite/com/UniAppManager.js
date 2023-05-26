//@charset UTF-8
/**
 * @singleton
 * 
 * 한 App에서 쓰이는 Grid / Store 를 통합 관리
 * 
 */
 Ext.define('Unilite.com.UniAppManager', {
    extend: 'Ext.util.MixedCollection',
    alternateClassName: ['UniAppManager','UniApp'],
    mixins: {
        observable: 'Ext.util.Observable'
    },
    requires: [    	
    	'Ext.util.MixedCollection'
    	//, 'Unilite.com.data.UniStore'
    	//, 'Unilite.com.state.UniStorageProvider'
	],
    
    singleton: true,
    app: null,
    appParams: null,
    id:'',

    constructor : function(){    
        var me = this;
        me.callParent(arguments);
        //me.addEvents('datachanged');
        
	    me.grids= new Ext.util.MixedCollection();
	    me.stores= Array();
	    me.stateInfo = {};
	    
		window.onbeforeunload = function(e) {
			var app = this.UniAppManager.getApp();
			if(app && app.isDirty()) {
		    	return '저장되지 않은 자료가 있습니다. 저장하지 않은채로 다른 페이지로 가시겠습니까?';
			}
		}
		
    	me.updateStatus("Page Loaded", true)
        console.log('UniAppManager constructor.');
    },
    /**
     * uniStore, uniGrid
     * 
     * @static
     */
    register : function() {
    	var me = this;
	    for (var i = 0, s; (s = arguments[i]); i++) {
	        if (s instanceof Unilite.com.data.UniStore) {
	        	//console.log('Register Store:', s.storeId, s);
	        	// Data load나 Sync 후
	        	//s.on('datachanged', this._dataChangedFun, this);
	        	//하나의 데이타가 수정이 일어 났을때
	        	//s.on('update', this._dataUpdatedFun, this);
	        	this.stores.push(s);
	        } else if(s instanceof Ext.grid.Panel) {
	        	console.log("Register Grid:", s.id);

	        	this.grids.add(s.id, s);
	        }
	    }
	},
	/**
	 * Main화면에 메시지를 전송 한다.
	 * 
	 * @param {} message
     * @static
	 */
	updateStatus: function(message, statusOnly) {
		if(parent && parent.updateStatus ) {
			parent.updateStatus(message);
		}
		var lStatusOnly = false ;
		if(statusOnly) {
			lStatusOnly = statusOnly;
		}
		if(!statusOnly) {
        	UniUtils.msg('확인', message);
		}
	},
	
	/**
	 * 
	 * @param {} newApp
	 */
	setApp: function(newApp) {
		this.app = newApp;
		
		console.log("app registered. id = ", this.id);
	},
	/**
	 * 
	 * @return {}
	 */
	getApp: function() {
		return this.app;
	},
	/**
	 * 다른 app 에게 전달할 params 저장
	 * @param {} params
	 */
	setAppParams: function(params) {
		this.appParams = params;
	},
	getAppParams: function() {
		return this.appParams;
	},
	/**
	 * 그리드 설정 값을 DB에 저장한다.
     * @static
	 */  
	saveGridState: function() {
		var me = this;
		var provider = Ext.state.Manager.getProvider();
		var state = new Array();
		for(i=0,len = me.grids.length; i < len; i++ ) {
			var grid = me.grids.get(i);			
			if(grid instanceof Ext.grid.Panel) {
				var gid = me.id + grid.getId();	// not using
				var shtInfo = provider.get(grid.getId());
				state.push({"type":"grid", "id": grid.getId(), "shtInfo" :  shtInfo} ) ;
				console.log("SAVE Grid STATE : id",grid.getId(), "shtInfo : " , shtInfo  ) ;
			}
		}
		if(Ext.isDefined(extJsStateProviderService.updateState)) {
	    	var params = {PGM_ID:this.id, type:'SAVE', SHT_INFO:provider.encodeValue(state)};
	    	extJsStateProviderService.updateState(params);
		}
		
		//참고: AppConfigTag 에 의해 매 화면마다 자바스크립트로 db의 상태정보(shtInfo) 값이 전달된다.
		//    상태 정보를 불러들이는 곳은 layout_extjs.js 의 provider.setStore(...) 에서 UniStorageProvider 의 _buildState 이다.
	},
	/**
	 * 그리드 설정 값을 DB로 부터 읽어 온다.
     * @static
	 */ 
	loadGridState:function() {
		var provider = Ext.state.Manager.getProvider();
		if(Ext.isDefined(extJsStateProviderService.getState)) {
	    	var params = {PGM_ID:this.id};
	    	extJsStateProviderService.getState(params, function(response, e) {  
    		if(Ext.isDefined(response)) {
	    		var shtInfo = provider.decodeValue(response.VALUE);
	    		provider.setStore( Ext.create('Ext.data.Store', {
						storeId: "STATE_STORE",
					 	fields: ["id","shtInfo"],
					 	idProperty : 'id',
					 	data: shtInfo
				}));
				/* reconfig후 grid 화면 reset됨 !!!
		    		if(Ext.isDefined(shtInfo)) {
		    			for(i =0, len = shtInfo.length; i < len; i++ ) {
		    				var info = shtInfo[i];
		    				console.log(i, info);
		    				var grid = Ext.getCmp(info.id);
		    				grid.view.refresh();
		    				//grid.reconfigure(grid.store,  info.shtInfo);
		    				//provider.set(info.id,info.shtInfo);
		    				grid.reconfigure(undefined,  info.shtInfo);
		    				console.log("reconfigure grid-", info.id, info.shtInfo);
		    				
		    			}		    			
		    		}	
		    		*/  		
	    		}
	    	});   
	    }
	},
	/**
	 * DB에 저장된 그리드의 설정값을 초기화 한다. 
	 * 단, 화면을 refresh 해야 적용됨 
     * @static
	 */
	resetGridState: function() {
		
		var provider = Ext.state.Manager.getProvider();
		console.log('grid 환경 기본값 설정');
		for(i=0,len<this.grids.length; i < len; i++ ) {
			var grid = this.grids.get(i);		
			if(grid instanceof Ext.grid.Panel) {
				console.log(this.id + "-Grid " + i + ": ",grid	);
				Ext.state.Manager.clear(grid.getItemId());
			}
		}
		if(Ext.isDefined(extJsStateProviderService.resetState)) {
			var params = {PGM_ID:this.id};
			extJsStateProviderService.resetState(params, function(response, e) {  
		    		if(Ext.isDefined(response)) {
			    		var obj = provider.decodeValue(response.SHT_INFO);
			    		console.log("OBJ:", obj);
			    		alert("화면을 닫았다 다시 열면 sheet 기본 설정이 적용 됩니다.");
		    		}
		    	}); 
		};

	},
	/**
	 * grid 상태정보를 불러와서 grid 에 적용한다.
	 * @param {} stateInfo	db에 저장되어 있는 설정 정보 (encoded)
	 */
	applyGridState: function(stateInfo) {		
		var provider = Ext.state.Manager.getProvider();
		var state = provider.decodeValue(stateInfo.SHT_INFO);	//db의 STH_INFO 값
		console.log('grid 환경 설정 적용');
		provider.setStore( Ext.create('Ext.data.Store', {
				storeId: "STATE_STORE",
			 	fields: ["id","shtInfo"],
			 	idProperty : 'id',
			 	data: state
		}));
		
		if(Ext.isDefined(state)) {
			var obj = Ext.getCmp(state.id);
			if(obj && obj instanceof Unilite.UniGridPanel) {
				//grid.getView().refresh();
				//grid.reconfigure(grid.store,  info.shtInfo);
				//provider.set(info.id,info.shtInfo);
				//grid.reconfigure(undefined,  state.shtInfo);
				//grid.reconfigure(grid.getStore(), state.shtInfo.columns);

				//그리드에 적용
				obj.setLoading(true);
				var cnt = obj.getStore().count();
				if(cnt > 0)
					obj.getStore().removeAll();	//data 가 있는 경우 속도에 문제가 생김.
				
				obj.applyState(state.shtInfo);
				
				if(cnt > 0)
					obj.getStore().reload();
					
				obj.setLoading(false);
				
				if(stateInfo.DEFAULT_YN == 'Y') {	//기본설정이 변경 적용되는 경우
					this.setStateInfo(stateInfo);
				}
				
				console.log("applyState grid-", state.id, state.shtInfo);	
			}
		}	
	},
	/**
	 * @private
	 * @param {} store
	 * @return {Boolean}
	 */
	_hasDirty:function(store) {
		var toCreate = store.getNewRecords(),
            toUpdate = store.getUpdatedRecords(),
            toDestroy = store.getRemovedRecords();
            /*
            console.log("STORE:", store.storeId, 
            		"toCreate:"+ toCreate.length,            		
            		"toUpdate:"+ toUpdate.length,
            		"toDestroy:"+ toDestroy.length
            	);
            	*/
        if(toCreate.length + toUpdate.length + toDestroy.length > 0) {
        	return true;
        } else {
        	return false;
        }
	},
	// ptivate
	/*
	_dataChangedFun: function(store, eOpts) {
		var me = this, hasDirty = false;
		
		for(i = 0, len = this.stores.length; i < len; i ++) {
			var lStore = this.stores[i];
			var l = me._hasDirty(lStore);
			if(l) {
				hasDirty = true;
				break;
			}
		}
		
		this.hasDirty = hasDirty;	
        me.fireEvent('datachanged',  me.app);	
	},
	*/
	// ptivate
	/*
	_dataUpdatedFun: function(store, record, operation, modifiedFieldNames, eOpts) {
		console.log("_dataUpdatedFun");
		var me = this;
		this.hasDirty = true;
        me.fireEvent('datachanged',  me.app);
	},
	*/
	
	/**
	 * 툴바 버튼 제어 
	 * 
	 *     UniApp.setToolbarButtons(['delete'], false);
	 *     UniApp.setToolbarButtons(['prev','next'], true);
	 *     
	 * @param {Array} btnNames
	 * @param {Boolean} state
     * @static
	 */
	setToolbarButtons:function(btnNames, state) {
		if(this.app) {
			this.app.setToolbarButtons(btnNames, state);
		}
	},
	setPageTitle: function(title) {
		if(parent && parent.updateProgramTitle ) {
			parent.updateProgramTitle(title);
		}
//        var tit = Ext.getCmp('UNILITE_PG_TITLE');
//        console.log('tit:', tit);
	},
	addButton: function( button ) {
		if(this.app) {
			this.app.addButton(button);
		}
	},
	saveState: function(id, state) {
		var provider = Ext.state.Manager.getProvider();
	}, 
	getState: function(id) {
		
		var provider = Ext.state.Manager.getProvider();
		var state = provider.get(id);
		return state
	},
	getDbShtInfo: function(id) {		
		var provider = Ext.state.Manager.getProvider();
		var StateInfo = {"type":"grid", "id": id, "shtInfo" :  provider.get(id)} 
		
		return provider.encodeValue(StateInfo);
	},
	setStateInfo: function(stateInfo) {
		this.stateInfo[stateInfo.SHT_ID] = stateInfo;	
	},
	getStateInfo: function(id) {
		return this.stateInfo[id];	
	}
	
});