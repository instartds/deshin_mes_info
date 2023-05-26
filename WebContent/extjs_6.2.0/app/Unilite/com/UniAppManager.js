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
	 * 
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
	 * 
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
     * 
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
				if( Ext.isDefined(provider.store)) {
	    	 		provider.store.data.each(function(item, index, totalItems ) {
						provider.fireEvent("statechange", provider, stateInfo.SHT_ID, null);
	    	 		});
				}
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
     * 
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
			    		Unilite.messageBox("화면을 닫았다 다시 열면 sheet 기본 설정이 적용 됩니다.");
		    		}
		    	}); 
		};

	},
	applyGridState2: function(stateInfo, grid) {		
		var provider = Ext.state.Manager.getProvider();
		if(!stateInfo)	{
			return;
		}
		
		if( stateInfo.SHT_ID != grid.getId() && provider.decodeValue(stateInfo.SHT_INFO).id != grid.getId())	{
			var stateCombo = Ext.getCmp(grid.getId()+'StateCombo');
			stateCombo.setValue("0");
			return;
		}
		var state = provider.decodeValue(stateInfo.SHT_INFO);	//db의 STH_INFO 값
		
		/* 그리드 컬럼 정보 변경 확인*///BASE_SHT_INFO
		var columns = grid.config.columns;
		var savedColumnsStr = stateInfo.COLUMN_INFO;
		var checkChange = false;
		var addColumns = new Array(), removeColumns = new Array();
		if(savedColumnsStr && state )	{
			savedColumns = JSON.parse(savedColumnsStr);
			//변경이 있는지 확인
			if(columns.length != savedColumns.length)	{
				checkChange = true;
			}
			Ext.each(columns, function(column, idx){
				if(idx < savedColumns.length)	{
					if(column.dataIndex != savedColumns[idx].dataIndex)	{
						checkChange = true;
					}
				}
			});
			if(checkChange)	{
				var savedStateColumns = state.shtInfo.columns;
				var oldTmpArray = new Array();
				var oldStateTmpArray = new Array();
				var tmpArray = new Array();
				var stateTmpArray = new Array();
				
				// 기존의 기본 컬럼 순서대로 dataIndex 값 => id(h+index)에 맞는 dataIndex 값 찾기 위해 만든 Array.  
				Ext.each(savedColumns, function(column, idx){
					oldTmpArray.push(column.dataIndex);			
				});
				//저장된 stat 순서로 dataIndex 값 저장
				Ext.each(savedStateColumns, function(column, idx){
					var id = column.id.replace('h','');
					oldStateTmpArray.push({id:column.id, dataIndex:oldTmpArray[id-1], hidden:column.hidden, width:column.width, locked:column.locked});  
				});
				// 신규 colum id(h+idx)와 매핑되는 DataIndex array생성
				Ext.each(columns, function(column, idx){
					//신규 column에 기존 state정보 넣기
					var obj = {id:'h'+(idx+1), dataIndex:column.dataIndex};
					Ext.each(oldStateTmpArray, function(column2, idx2){
						if(column.dataIndex == column2.dataIndex)	{
							obj.oldId = column2.id;
							if(column2.hidden){
								obj.hidden = column2.hidden;
							}
							if(column2.width){
								obj.width = column2.width;
							}
							if(column2.locked){
								obj.locked = column2.locked;
							}
							return;
						}
					});
					tmpArray.push(obj);
				});
				// 저장된 state 정보 column 순서 대로 신규 컬럼 id에 맞도록 array(stateTmpArray) 만들기, 생성시 삭제된 컬럼은 포함 안됨
				cIdx=1;
				if(grid.uniOpt && grid.uniOpt.useRowNumberer )	{
					stateTmpArray.push({id:'h'+(cIdx)});
					cIdx++
				}
				//checkboxModel 인 경우 첫 컬럼제외
				if(grid && grid.getSelectionModel().type != "rowmodel" && grid.getSelectionModel().type != "spreadsheet"  )	{
					stateTmpArray.push({id:'h'+(cIdx)});
					cIdx++
				}
				Ext.each(oldStateTmpArray, function(column, idx){
					Ext.each(tmpArray, function(column2, idx2){
						if(!Ext.isEmpty(column.dataIndex) && !Ext.isEmpty(column2.dataIndex) )	{
							if(column.dataIndex == column2.dataIndex)	{
								var obj = new Object();
								obj.id = column2.id;
								if(column.hidden){
									obj.hidden = column.hidden;
								}
								if(column.width){
									obj.width = column.width;
								}
								if(column.locked){
									obj.locked = column.locked;
								}
								stateTmpArray.push(obj);
								cIdx++;
								return;
							}					
						}
					});
				});
				//추가된 필드 추가
				Ext.each(tmpArray, function(column, idx){
					if(!column.oldId){
						stateTmpArray.push({id:column.id});
						cIdx++;
					}
				});
				if(grid.uniOpt && grid.uniOpt.expandLastColumn )	{
					stateTmpArray.push({id:'h'+(cIdx)});
				}
				state.shtInfo.columns = stateTmpArray;
				
				//Group : 저장된 grouper 필드가 삭제 되었다면 설정에서 지움.
				var oldStoreState = state.shtInfo.storeState;
				if(oldStoreState)	{
					var oldGrouper = oldStoreState.grouper;
					var removeGrouper = true;
					if(oldGrouper)	{
						var oldProperty = oldGrouper.property;
						if(oldProperty)	{
							Ext.each(tmpArray, function(column, idx){
								if(oldProperty == column.dataIndex)	{
									removeGrouper = false;
								}
							})
						}
					}
					if(removeGrouper){
						state.shtInfo.storeState.grouper= null;
					}
				}
				//Sorter : 저장된 Sorter 필드가 삭제 되었다면 설정에서 지움.
				if(oldStoreState)	{
					var oldSorters = oldStoreState.sorters;
					var newSorters = new Array();
					if(oldSorters)	{
						Ext.each(oldSorters, function(sorter, idx)	{
							var hasColum = false;
							Ext.each(tmpArray, function(column, idx){
								if(sorter.property == column.dataIndex)	{
									hasColum = true;
								}
							})
							if(hasColum)	{
								newSorters.push(sorter);
							}
						});
					}
					if(!Ext.isEmpty(newSorters))	{
						state.shtInfo.storeState.sorters = newSorters;
					}else {
						state.shtInfo.storeState.sorters = null;
					}
				}
				//Filter : 저장된 Filter 필드가 삭제 되었다면 설정에서 지움.
				if(oldStoreState)	{
					var oldFilters = oldStoreState.filters;
					var newFilters = new Array();
					if(oldFilters)	{
						Ext.each(oldFilters, function(filter, idx)	{
							var hasColum = false;
							Ext.each(tmpArray, function(column, idx){
								if(filter.property == column.dataIndex)	{
									hasColum = true;
								}
							})
							if(hasColum)	{
								newFilters.push(filter);
							}
						});
					}
					if(!Ext.isEmpty(newFilters))	{
						state.shtInfo.storeState.filters = newFilters;
					}else {
						state.shtInfo.storeState.filters = null;
					}
				}
			}
		} else {
			if(columns && state && columns.length != state.shtInfo.columns.length)	{
				state =  provider.decodeValue(grid.baseShtInfo.SHT_INFO);
			}
		}
		
		console.log('grid 환경 설정 적용');
		var isCreatedStatStore = false;
		var stateStore = Ext.data.StoreManager.lookup("STATE_STORE");
		if(stateStore)	{
			if(stateStore && stateStore.getData())	{
				isCreatedStatStore = true;
				var setData = false;
				Ext.each(stateStore.getData().items, function(sData, idx){
					if(sData.get("id") == state.id)	{
						sData.set(state);
						setData = true;
					}
				})
				if(!setData){
					stateStore.insert(stateStore.getData().items.length, state);
				}
			}
		} 
		if(!isCreatedStatStore) {
			provider.setStore( Ext.create('Ext.data.Store', {
					storeId: "STATE_STORE",
				 	fields: ["id","shtInfo"],
				 	idProperty : 'id',
				 	data: state
			}));
		}
		
		provider.fireEvent("statechange", provider, stateInfo.SHT_ID, null);
		
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
				
				if(state.shtInfo && state.shtInfo.columns )	{
					var orgStateColumns = state.shtInfo.columns;
					var stateColumns = new Array();
					Ext.each(orgStateColumns, function(stateColumn, idx) {
						UniAppManager._getStateColumnInColumn(stateColumn, stateColumns);
					});
					var gridColumns = obj.getColumns();
					Ext.each(stateColumns, function(column, i){
						var columnId = column.id
						var idx = i;
						Ext.each(gridColumns, function(gridcolumn, gridIdx){
							if(gridcolumn.stateId == columnId)	{
								idx = gridIdx;
							}
						});
						if(column.hidden || Ext.isDefined(column.hidden))	{
							gridColumns[idx].hide();
							if(column.hidden == false)	{
								gridColumns[idx].show();
							}
						}else if( gridColumns[idx] && Ext.isDefined(gridColumns[idx].initialConfig) && Ext.isDefined(gridColumns[idx].initialConfig.hidden) &&  !gridColumns[idx].initialConfig.hidden) {
							gridColumns[idx].show();
						}else if( gridColumns[idx] && Ext.isDefined(gridColumns[idx].initialConfig) && Ext.isDefined(gridColumns[idx].initialConfig.hidden) &&  gridColumns[idx].initialConfig.hidden) {
							gridColumns[idx].hide();
						}else if( gridColumns[idx] && Ext.isDefined(gridColumns[idx].initialConfig) && !Ext.isDefined(gridColumns[idx].initialConfig.hidden) )	{
							gridColumns[idx].show();
						}
						
						if(column && Ext.isDefined(gridColumns[idx]) )	{
							if( !column.locked &&  Ext.isDefined(gridColumns[idx].initialConfig) && gridColumns[idx].initialConfig.locked)	{
								gridColumns[idx].locked = true;
								if(obj.lockable) {
									obj.lock(gridColumns[idx], idx);
								}
							} else {
								gridColumns[idx].locked = false;
								if(obj.lockable) {
									obj.unlock(gridColumns[idx], idx);
								}
							}
						}
					})
					
				}		
				var gridStore = obj.getStore();
				gridStore.clearGrouping( );
				gridStore.clearFilter(true);
				if(gridStore.sorters && gridStore.sorters.length > 0) gridStore.sorters.clear();
				
				obj.getView().refresh();
				
				if(!obj.getStore().isDirty())	{
					var cnt = obj.getStore().count();
					if(cnt > 0)	{
						obj.getStore().removeAll();	//data 가 있는 경우 속도에 문제가 생김.
						obj.getStore().commitChanges();
					}
					obj.applyState(state.shtInfo);
					//header.setLoading(true);
					if(cnt > 0)	{
						//obj.getStore().applyState(state.shtInfo.storeState);
						obj.getStore().reload();
					}
				}
				obj.setLoading(false);
				stateInfo.DEFAULT_YN = 'Y';
				this.setStateInfo(stateInfo);
				
				console.log("applyState grid-", state.id, state.shtInfo);	
			}
		}	
	},
	_getStateColumnInColumn:function(column, stateColumns)	{
		
		if(!column.columns) { 
			stateColumns.push(column) 
		} else {
			Ext.each(column.columns, function(col, idx)	{
				UniAppManager._getStateColumnInColumn(col, stateColumns);
			});
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
	
	
	/**
	 * 툴바 버튼 제어 
	 * 
	 *     UniApp.setToolbarButtons(['delete'], false);
	 *     UniApp.setToolbarButtons(['prev','next'], true);
	 *     
	 * @param {Array} btnNames
	 * @param {Boolean} state
     * 
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