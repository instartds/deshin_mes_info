//@charset UTF-8
/**
 * Unilite용 Direct Store / 데이타 수정이 필요한 곳에만 사용 !
 *  * Sync시 (create, update, delete가 하나의 sync 함수로 통합함)
 */
Ext.define('Unilite.com.data.UniTreeStore', {
    extend: 'Ext.data.TreeStore',
    alias: 'store.uniTreeStore',
    
    requires: [
    	'Ext.data.proxy.Direct', 
    	'Unilite.com.data.UniWriter',
    	'Unilite.com.UniAppManager'
    ],
    // Unilite용으로 확장된 옵션 사항.
    uniOpt : {
    	isMaster:	true, 		// 버튼과 상태 바에 메시지 전송 여부 
    	editable:	false,		// 수정 가능 여부
    	deletable:	false,		// 삭제 가능 여부 
    	useNaviBtn:	false,		// prev/next 버튼 사용 여부
    	state: {'btnDelete':false}				// 상태-tab이동시 사용 
    },
	
	
    constructor : function(config){
    	var me = this;
        config = Ext.apply({}, config);
       
        //Ext.apply(config.proxy, config, 'paramOrder,paramsAsHash,directFn,api,simpleSortMode');
		//Ext.apply(config.proxy.reader, config, 'totalProperty,root,idProperty');
		Ext.apply(config.proxy, {
				writer:'uniWriter',
				batchActions: true,
				batchOrder : 'destroy,create,update',
				listeners: {
                	exception : {
                		fn: function(proxy, response, operation, eOpts) {
                			// 서버 오류발생시 (validation 오류 포함)
                			me._onExceltion(proxy, response, operation, eOpts);
                		},
                		scope:this
                	}
                	
                }
		});
        me.callParent([config]);
        UniAppManager.register(this);   
		Ext.applyIf(this.uniOpt, {state:{btn:{}}});  
    	
        //
   		me.on('update', me._onStoreUpdate, me);
 		me.on('load', me._onStoreLoad, me);
 		me.on('datachanged', me._onStoreDataChanged, me);
   		me.on('remove', me._onChildRemove, me);

    } // initComponent
    ,count:function() {
    	var obj = this.tree.flatten();
    	return 1;
    }
    ,_onChildRemove: function(node, deletedNode, isMove, eOpts ) {
    	if(!node.hasChildNodes( )) {
    		node.set('leaf', true);
    	}
    	// 삭제후 store에 변경 notice (강제로 save 버튼 활성화)
    	this._onStoreDataChanged(this,eOpts, true);
    }
	, onStoreActionEnable : function(eOpts)	{
		var tmpIsMaster = this.uniOpt.isMaster;
		this.uniOpt.isMaster = true;
		this._onStoreDataChanged(this,eOpts);
		this.uniOpt.isMaster = tmpIsMaster;
	}
	// 주의 !!! 
    //,_onStoreUpdate:function (store, eOpt) {
    ,_onStoreUpdate:function (store, record, operation, modifiedFieldNames, eOpts) {
    	if(modifiedFieldNames != 'modifiedFieldNames' && this.uniOpt.isMaster) {
	    	//console.log("Store data updated save btn enabled !"+ this.isLoading( ) );
	    	UniAppManager.setToolbarButtons('save', true);
    	}
    } // onStoreUpdate
    ,_onStoreLoad:function ( store, records, successful, eOpts ) {
    	if(this.uniOpt.isMaster) {
	    	console.log("onStoreLoad");
	    	if (records) {
		    	UniAppManager.setToolbarButtons('save', false);
				var msg = '조회되었습니다.';
		    	//console.log(msg, st);
		    	UniAppManager.updateStatus(msg, true);	    	
	    	}
    	}
    } //onStoreLoad
   
    ,_onStoreDataChanged : function( store, eOpts , lForce)	{
    	if(this.uniOpt.isMaster) {
       		var rootNode = store.getRootNode();
       		console.log(" store.count() : ", store.count());
       		if(store.count() == 0)	{
       			UniApp.setToolbarButtons(['delete'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'delete':false}});
	    		if(this.uniOpt.useNavi) {
	       			UniApp.setToolbarButtons(['prev','next'], false);
	    		}
       		}else {
       			if(this.uniOpt.deletable)	{
	       			UniApp.setToolbarButtons(['delete'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'delete':true}});
       			}
	    		if(this.uniOpt.useNavi) {
	       			UniApp.setToolbarButtons(['prev','next'], true);
	    		}
       		}
       		if(store.isDirty() || lForce)	{
       			UniApp.setToolbarButtons(['save'], true);
       		}else {
       			UniApp.setToolbarButtons(['save'], false);
       		}
    	}
    } // onStoreDatachanged
    ,_onExceltion:function(proxy, response, operation, eOpts) {
    	 Ext.MessageBox.show({
		                    title: 'REMOTE EXCEPTION',
		                    msg: operation.getError(),
		                    icon: Ext.MessageBox.ERROR,
		                    buttons: Ext.Msg.OK
		                });
    },

    
     
    /**
     * 저장할 것이 있는지 확인
     * extjs의 isDirty와 의미가 조금 다름.
     * @return {}
     */
    isDirty:function() {
    	var me = this, needsSync = false;
        var toCreate = Ext.Array.filter(this.tree.flatten(), this.filterNew);
        var toUpdate = Ext.Array.filter(this.tree.flatten(), this.filterUpdated);
        var toDestroy = me.getRemovedRecords();
            

        if (toCreate.length > 0 || toUpdate.length > 0 || toDestroy.length > 0) {
            needsSync = true;
        }
        return needsSync;
    },
    // Ext.data.AbstractStore
    // filterNew : item.phantom === true && item.isValid();
    // filterUpdated : item.dirty === true && item.phantom !== true && item.isValid();
    // 
    filterInvalidUpdatedRecords:function (item) {
    	return item.dirty === true && item.phantom !== true && !item.isValid();
    },
    filterInvalidNewRecords:function (item) {
    	// dirty는 저장안된것 !!!(추가건에 수정이 없으면 dirty에 안걸림)
    	return item.phantom === true && !item.isValid();
    },
    getInvalidRecords: function() {
    	//return this.data.filterBy(this.filterInvalid).items;
    	//return [].concat(this.data.filterBy(this.filterInvalidNewRecords).items, this.data.filterBy(this.filterInvalidUpdatedRecords).items);
    	var a1 = Ext.Array.filter(this.tree.flatten(), this.filterInvalidNewRecords);
    	var a2 = Ext.Array.filter(this.tree.flatten(), this.filterInvalidUpdatedRecords);
    	return [].concat( a1, a2 );
    },
    /**
     * 
     * @param {} options
     * @return {}
     */
    syncAll: function(options) {
    	
    	// 유효한 레코드 들만 가져옮
        var me = this,
            operations = {syncAll:{}},
            toCreate = me.getNewRecords(),
            toUpdate = me.getUpdatedRecords(),
            toDestroy = me.getRemovedRecords(),
            needsSync = false;

        if (toCreate.length > 0) {
            operations.create = toCreate;
            operations.syncAll.create = toCreate;
            needsSync = true;
        }

        if (toUpdate.length > 0) {
            operations.update = toUpdate;
            operations.syncAll.update = toUpdate;
            needsSync = true;
        }

        if (toDestroy.length > 0) {
            operations.destroy = toDestroy;
            operations.syncAll.destroy = toDestroy;
            needsSync = true;
        }

        if (needsSync && me.fireEvent('beforesync', operations) !== false) {
            options = options || {};
			options=Ext.apply(options, {
                operations: operations,
                listeners: me.getBatchListeners()
            });
            options=Ext.apply(options, {
            	callback: function(batch, option) {
            		//UniAppManager.updateStatus("저장되었습니다.");
            		console.log()
            		Ext.getBody().unmask();
            	}
            });
            Ext.getBody().mask();
            me.proxy.batch(options);
        }
        
        return me;
    }
    
}); // Ext.define