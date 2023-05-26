//@charset UTF-8
/**
 * Custom proxy to read from another store
 * 출처 :  
 * 	http://www.sencha.com/forum/showthread.php?153116
 * 	http://www.sencha.com/forum/showthread.php?152057-Custom-proxy-to-read-from-another-store
 * 
 */
Ext.define('Unilite.com.data.proxy.UniStoreProxy', {
    extend: 'Ext.data.proxy.Proxy',
    alias: 'proxy.store',
    alternateClassName: ['Test.data.StoreProxy'],
    unsyncedRecords: [],
 
    constructor: function(config) {
        //call the parent cosntructor
        config = config || {};
        this.callParent([config]);
        this.sourceStore = config.sourceStore;
    
        if (this.sourceStore === undefined) {
            Ext.Error.raise("You have to provide a parent store");
        }
        this.initialize();
    },
    
    initialize: function(){
        var me = this;
        if( typeof( this.sourceStore ) == 'string' ){
            //the store was given to us by id so let's get it from store manager
            this.sourceStore = Ext.data.StoreManager.lookup( this.sourceStore );
            if( this.sourceStore === undefined ){ //the parent store was not loaded, let's do that
                this.sourceStore = Ext.create(this.sourceStore);
            }
        }
        //replace the afterRequest function of the source proxy so that we can listen to the events
        if( this.sourceStore.getProxy().afterRequest ===  Ext.emptyFn){
            this.sourceStore.getProxy().afterRequest = this.sourceProxyAfterRequest;
            this.sourceStore.getProxy().addEvents( 'afterrequest' );
        }
        
        //monitore the operations of the remote store's proxy
        this.sourceStore.getProxy().on('afterrequest', this.onSourceStoreProxyOperation, me);
        
    },
    
    sourceProxyAfterRequest: function(request, success){
        this.fireEvent('afterrequest', request, success);
    },
    
    onSourceStoreProxyOperation: function(request, success){
        
        var me = this,
            operation = request.operation,
            records = operation.getRecords(),
            i, record,
            opeartionId;
            
        if( request.action != 'read' && request.records.length  ){
            opeartionId = request.records[0].operationId;
        }
        
        if( opeartionId && this.unsyncedRecords[opeartionId]) { //this is an operation initiated by us
            
            switch (operation.action) {
                case 'create':
                    if (success === true) {
                        if (operation.wasSuccessful() !== false) {
                            //we just need to change the record id's in our store
                            for(i = 0; i < records.length; i++){
                                record =this.unsyncedRecords[opeartionId].records[i]
                                record.setId( records[i].getId() );
                                record.commit();
                                
                            }
                        }
                    }
                    break;
                case 'update':
                    break;
                case 'destroy': //nothing to do on destroy
                    break;
            }
        }
    },
    
    create: function(operation, callback, scope) {
        //since the post to another store in immidiate we behave much liek the web store
        var records = operation.records,
            length  = records.length,
            id, record, i, 
            operationId = Math.floor(Math.random()*100001),
            sourceRecords = [];


        for(i = 0; i < length; i++){
            sourceRecords[i] = records[i].copy();
            sourceRecords[i].phantom = true;
            sourceRecords[i].operationId = operationId;//carry over the operation id
        }
        


        for (i = 0; i < length; i++) {
            record = records[i];
            if (record.phantom) {
                record.phantom = false;
                id = Math.floor(Math.random()*100000001) * -1;
            } else {
                id = record.getId();
            }
            record.setId(id);
            record.commit();
        }
        
        this.sourceStore.add(sourceRecords);
        
        operation.setCompleted();
        operation.setSuccessful();


        if (typeof callback == 'function') {
            callback.call(scope || this, operation);
        }
        
        //remember this transaction so that later we can set the record ids to the real values
        this.unsyncedRecords[operationId] = {
            records: records,
            sourceRecords: sourceRecords
        }
        
        
    },
    
    read: function(operation, callback, scope) {


        var me     = this,
            records = [],
            count = this.sourceStore.getCount(),
            result;
                
        for ( var row = 0; row < count; row++ ) {
          records.push( this.sourceStore.getAt( row ).copy() );
        }
        
        result = Ext.create('Ext.data.ResultSet', {
            total  : this.sourceStore.getTotalCount(),
            count  : count,
            records: records,
            success: true
        });


        Ext.apply(operation, {
            resultSet: result
        });


        operation.setCompleted();
        operation.setSuccessful();
        Ext.callback(callback, scope || me, [operation]);
    },


    update: function(operation, callback, scope) {
        var records = operation.records,
            length  = records.length,
            rawData,
            operationId = Math.floor(Math.random()*100001),
            id, record, i;
        
        for (i = 0; i < length; i++) {
            record = records[i];
            rawData = {};
            record.fields.each(function(field) {
                rawData[field.name] = record.get(field.name);
            });
            this.sourceStore.getById( record.getId() ).set( rawData );
            record.commit();
        }
        
        operation.setCompleted();
        operation.setSuccessful();
        if (typeof callback == 'function') {
            callback.call(scope || this, operation);
        }
    },
   
    destroy: function(operation, callback, scope) {
        var record, i,
            records = operation.getRecords();
        operation.setStarted();
        for(i = 0; i < records.length; i++){
            record = this.sourceStore.getById( records[i].getId() );
            this.sourceStore.remove( record );
        }
        operation.setCompleted();
        operation.setSuccessful();
    },
    
    writeOperation: function(operation, callback, scope) {
        var me = this,
            autoSyncValue,
            options = {},
            listeners = {
                scope: me,
                exception: function(batch, operation){ 
                    var sourceListeners = this.sourceStore.getBatchListeners();
                    Ext.callback(sourceListeners.exception, this.sourceStore, [batch, operation]);  
                },
                operationcomplete: function(batch, operation){ 
                    var sourceListeners = this.sourceStore.getBatchListeners();
                    if( sourceListeners.operationcomplete ){
                        Ext.callback(sourceListeners.operationcomplete, this.sourceStore, [batch, operation]);
                    }
                    Ext.callback(callback, scope, [operation]);
                },
                complete: function(batch, operation){ 
                    var sourceListeners = this.sourceStore.getBatchListeners();
                    if( sourceListeners.complete ){
                        Ext.callback(sourceListeners.complete, this.sourceStore, [batch, operation]);
                    }
                    //Ext.callback(callback, scope, [operation]);
                }
            },
            records = operation.getRecords();
        
        operation.setStarted();
        if (true){ //for now we force the sync since currenctly there is no way to get notified by the sourceStore when this operation is completed
        //if (this.sourceStore.autoSync) {
            //sync the data back to the server and tell both stores about the result
            switch( operation.action ){
                case 'create':
                    options.create = records;
                    break;
                case 'update':
                    options.update = records;
                    break;
            }
            this.sourceStore.getProxy().batch(options, listeners);
        }
    }

}); // Ext.define