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
    //5.1에서 root 설정을 안해주면 load 후 root를 expand 해줘야 그리드에 트리노드들이 보여진다.(bug??)
    root: {
	    expanded: false,
	    children: []
	},
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
				writer: Ext.create('Unilite.com.data.UniWriter'), //'uniWriter',
				batchActions: true,
				batchOrder : 'destroy,create,update',
				listeners: {
                	exception : {
                		fn: function(proxy, response, operation, eOpts) {
                			// 서버 오류발생시 (validation 오류 포함)
                			me._onException(proxy, response, operation, eOpts);
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
   		//me.on('remove', me._onChildRemove, me);
 		me.on('noderemove', me._onChildRemove, me);
 		me.on('removeselected', me._onRemoveSelected, me);

    } // initComponent
//    ,count:function() {
//    	var obj = this.tree.flatten();
//    	return 1;
//    }
    ,getNodeCount: function() {
    	var map = Ext.Object.getValues(this.byIdMap);
    	//root 제외
    	return (map.length > 1 ? map.length -1 : 0)
    }
    //,_onChildRemove: function(node, deletedNode, isMove, eOpts ) {
    ,_onChildRemove: function(node, deletedNode, isMove, context, eOpts ) {
    	if(!node.hasChildNodes()) {
    		node.set('leaf', true);
    	}
    	// 삭제후 store에 변경 notice (강제로 save 버튼 활성화)
    	// 4.2 : datachanged -> noderemove 이벤트 순서였으나
    	// 5.1 : noderemove -> datachanged 로 변경되어 save 버튼 활성화 시켜도  datachanged 에서 다시 비활성화 시킨다.
    	//       -> datachanged 시점의 isDirty의  getRemovedRecords()가 removed record 체크가 안되고 잇고 force 파라미터도 넘겨받질 못하기 때문.
    	//		 -> tree 의 expand, collapse 시에 add/remove 이벤트가 발생하고 그에 따라 datachaged 이벤트 발생함.
    	//       -> 그래서,, removeselected 이벤트 리스너를 만들고 , treegridpanel 의 deleteSelectedRow 함수에서 removeselected 이벤트를 fire 하도록 하였다.
    	this._onStoreDataChanged(this,eOpts, true);
    }
    ,_onRemoveSelected: function( selnode) {
    	if(this.uniOpt.isMaster) {
    		this._onStoreDataChanged(this, null, true);
    	}
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
    ,_onStoreLoad:function ( store, records, successful, operation, node, eOpts  ) {
    	if(this.uniOpt.isMaster) {
	    	console.log("onStoreLoad");
	    	if (records) {
		    	UniAppManager.setToolbarButtons('save', false);
				var msg = this.getNodeCount() + Msg.sMB001; //'건이 조회되었습니다.';
		    	//console.log(msg, store);
		    	UniAppManager.updateStatus(msg, true);	    	
	    	}
    	}
    } //onStoreLoad
   
    ,_onStoreDataChanged : function( store, eOpts , lForce)	{
    	if(this.uniOpt.isMaster) {
       		//var rootNode = store.getRootNode();	//4.2.2
    		var rootNode = store.getRoot();	//5.1
       		//console.log(" store.count() : ", store.count());
       		//if(store.count() == 0)	{
    		if(this.getNodeCount() == 0)	{
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
    ,_onException:function(proxy, response, operation, eOpts) {
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
//        var toCreate = Ext.Array.filter(this.tree.flatten(), this.filterNew);
//        var toUpdate = Ext.Array.filter(this.tree.flatten(), this.filterUpdated);
    	var toCreate = me.getNewRecords();
        var toUpdate = me.getUpdatedRecords();
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
    	//4.2.2
//    	var a1 = Ext.Array.filter(this.tree.flatten(), this.filterInvalidNewRecords);
//    	var a2 = Ext.Array.filter(this.tree.flatten(), this.filterInvalidUpdatedRecords);
    	
    	//5.1
//    	var a1 = Ext.Array.filter(Ext.Object.getValues(this.byIdMap), this.filterInvalidNewRecords, this);
//    	var a2 = Ext.Array.filter(Ext.Object.getValues(this.byIdMap), this.filterInvalidUpdatedRecords);

//		var a1 = Ext.Array.filter(Ext.Object.getValues(this.getNewRecords()), this.filterInvalidNewRecords, this);
//   	var a2 = Ext.Array.filter(Ext.Object.getValues(this.getUpdatedRecords()), this.filterInvalidUpdatedRecords);

		var a1 = this.data.items.filter(this.filterInvalidNewRecords);
    	var a2 = this.data.items.filter(this.filterInvalidUpdatedRecords);   	
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
    },
     syncAllDirect: function(options) {
    	
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
            		console.log("callback exceptions :", batch.exceptions);
            		if(batch.exceptions && batch.exceptions.length < 1) {
            			UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.");
            			me.commitChanges();
            		}
            		Ext.getBody().unmask();
            	},
            	failure: function (optional){
            		Ext.getBody().unmask();
            	}
            });
            Ext.getBody().mask();
            me.proxy.syncAll(options);
        }
        
        return me;
    }
    
}); // Ext.define