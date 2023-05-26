//@charset UTF-8
/**
 * Unilite용 Direct Abstract Store 
 */
Ext.define('Unilite.com.data.UniAbstractStore', {
    extend: 'Ext.data.Store',
    
    // statefulFilters: true,	// store 필터 상태 정보 저장 시 필요함.
    
    // Unilite용으로 확장된 옵션 사항.
    uniOpt: {
        isMaster:   true,       // 버튼과 상태 바에 메시지 전송 여부 
        editable:   false,      // 수정 가능 여부
        deletable:  false,      // 삭제 가능 여부 
        useNaviBtn: false,      // prev/next 버튼 사용 여부
        state: {'btnDelete': false}             // 상태-tab이동시 사용 
    },
    // Ext.data.AbstractStore
    // filterNew : item.phantom === true && item.isValid();
    // filterUpdated : item.dirty === true && item.phantom !== true && item.isValid();
    // 
    filterInvalidUpdatedRecords: function (item) {
        return item.dirty === true && item.phantom !== true && !item.isValid();
    },
    filterInvalidNewRecords: function (item) {
        // dirty는 저장안된것 !!!(추가건에 수정이 없으면 dirty에 안걸림)
        return item.phantom === true && !item.isValid();
    },
    getInvalidRecords: function() {
        //return this.data.filterBy(this.filterInvalid).items;
        return [].concat(this.data.filterBy(this.filterInvalidNewRecords).items, this.data.filterBy(this.filterInvalidUpdatedRecords).items);
    },
    /**
     * filter에서 inValid record 포함하기 위해 override함
     * @return {}
     */
    getRejectRecords: function() {
        // Return phantom records + updated records
        return Ext.Array.push(this.data.filterBy(this.filterNewOnly).items, this.getUpdatedRecordsForReject());
    },
    getUpdatedRecordsForReject: function() {
        return (this.snapshot || this.data).filterBy(this.filterUpdatedForReject).items;
    },
    filterUpdatedForReject: function(item) {
        // only want dirty records, not phantoms that are valid
        return item.dirty === true && item.phantom !== true ;
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
            		console.log("callback exceptions :", batch.exceptions);
            		if(batch.exceptions && batch.exceptions.length < 1) {
            			UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.");
            		}
            		Ext.getBody().unmask();
            	},
            	failure: function (optional){
            		Ext.getBody().unmask();
            	}
            });
            Ext.getBody().mask();
            me.proxy.batch(options);
        }
        
        return me;
    },
    
    /**
     * 
     * @param {} options
     * @return {}
     */
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
});