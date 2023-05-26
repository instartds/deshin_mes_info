//@charset UTF-8


Ext.override(Ext.data.proxy.Server, {
	/* extjs 4.2.2
    // Should this be documented as protected method?
    processResponse: function(success, operation, request, response, callback, scope) {
    	
        var me = this,
            reader,
            result;

        if (success === true) {
            reader = me.getReader();

            // Apply defaults to incoming data only for read operations.
            // For create and update, there will already be a client-side record
            // to match with which will contain any defaulted in values.
            reader.applyDefaults = operation.action === 'read';
            
            // modified by lhj 2014.06.24 -------------------------------------
            //result = reader.read(me.extractResponseData(response));
            var isSyncAll = false
            if(operation.action && operation.action == 'syncAll')   {
                result = me.extractResponseData(response);
                isSyncAll = true;
            } else {
                result = reader.read(me.extractResponseData(response));
            }
            //----------------------------------------------------------------------
            
            if (result.success !== false) {
                //see comment in buildRequest for why we include the response object here
                Ext.apply(operation, {
                    response: response,
                    resultSet: result
                });
                
                if(!isSyncAll) {
                    operation.commitRecords(result.records);
                }
                operation.setCompleted();
                operation.setSuccessful();
            } else {
                operation.setException(result.message);
                me.fireEvent('exception', this, response, operation);
            }
        } else {
            me.setException(operation, response);
            me.fireEvent('exception', this, response, operation);
        }

        //this callback is the one that was passed to the 'read' or 'write' function above
        if (typeof callback == 'function') {
            
            if(!isSyncAll) {
                callback.call(scope || me, operation);
            }
        }

        me.afterRequest(request, success);
        
    	
    	
    }    
    */
	timeout:600000,
	processResponse: function(success, operation, request, response) {
        var me = this,
            exception, reader, resultSet;

        // Processing a response may involve updating or committing many records
        // each of which will inform the owning stores, which will ultimately
        // inform interested views which will most likely have to do a layout
        // assuming that the data shape has changed.
        // Bracketing the processing with this event gives owning stores the ability
        // to fire their own beginupdate/endupdate events which can be used by interested
        // views to suspend layouts.
        me.fireEvent('beginprocessresponse', me, response, operation);
        
        if (success === true) {
            reader = me.getReader();
            
            // modified by lhj 2014.11.19 -------------------------------------
            var isSyncAll = false
            if (response.status === 204) {
                resultSet = reader.getNullResultSet();
            } else {
                if(operation.action && operation.action == 'syncAll')   {
	                resultSet = me.extractResponseData(response);
	                Ext.apply(resultSet, {success: true})
	                isSyncAll = true;
	            } else {
	            	if(Ext.isEmpty(operation.getRecordCreator)) {
	            		resultSet = reader.read(me.extractResponseData(response));
	            	}else{
		                resultSet = reader.read(me.extractResponseData(response), {    
		                	// If we're doing an update, we want to construct the models ourselves.
			                recordCreator: operation.getRecordCreator()
			            });
	            	}
	            }
            	/*resultSet = reader.read(me.extractResponseData(response), {    
                	// If we're doing an update, we want to construct the models ourselves.
	                recordCreator: operation.getRecordCreator()
	            });*/
            }           
            //----------------------------------------------------------------------

            operation.process(resultSet, request, response);
            exception = !operation.wasSuccessful();
        } else {
            me.setException(operation, response);
            exception = true;
        }
        
        if (exception) {
            me.fireEvent('exception', me, response, operation);
        }

        me.afterRequest(request, success);
        
        // Tell owning store processing has finished.
        // It will fire its endupdate event which will cause interested views to 
        // resume layouts.
        me.fireEvent('endprocessresponse', me, response, operation);
    }
    
});

Ext.override(Ext.data.operation.Operation, {
    process: function(resultSet, request, response, autoComplete) {
        var me = this;
        
        autoComplete = autoComplete !== false;
        
        me.setResponse(response);
        me.setResultSet(resultSet);
        if (resultSet.success || resultSet.getSuccess()) {
        	//me.doProcess(resultSet, request, response);
        	if(!me.isSyncAllOperation) {
            	me.doProcess(resultSet, request, response);
        	}
            me.setSuccessful(autoComplete);
        } else if (autoComplete) {
            me.setException(resultSet.getMessage());
        }
    }
});

Ext.define('Ext.data.operation.SyncAll', {
    extend: 'Ext.data.operation.Operation',
    alias: 'data.operation.syncAll',
    
    action: 'syncAll',

    isSyncAllOperation: true,

    order: 40,

    config: {
        recordCreator: Ext.identityFn
    },
    
    doExecute: function() {
    	var proxy = this.getProxy();
        return proxy.doRequest.apply(proxy, this);
    }
});

/**
 * unilite용 proxy class
 */
Ext.define('Unilite.com.data.proxy.UniDirectProxy', {
	extend: 'Ext.data.proxy.Direct',
    alias: 'proxy.uniDirect',
    requires: [
    	'Ext.direct.Manager',
    	'Unilite.com.data.UniWriter'
    ],
    writer: 'uniWriter',
    batchActions:true,    
     //batchOrder: 'syncAll,create,update,destroy',
    batchOrder: 'destroy,create,update',
     
     /**

      * 추가/수정/삭제된 데이타를 server와 동기화 한다.
      * @return {}
      */
     /*
    syncAll: function() {
    	console.log("Proxy syncAll");
        return this.doRequest.apply(this, arguments);
    },*/
	
     /**
      * 하나의 Trancsaction 내에서 실행할 server 메소드들의 정보를 보낸다.
      * @return {}
      */
    doRequestSyncAll: function(batch, scope) {
    	var me = this,
    		operations = batch.operations,     
    		writer,
            request,
            operation,
            action,
            api,
            onOperationComplete,
            params,            
            args,
            fn, method;
       
        for(var index=0; index< operations.length; index++) {
        	args = [];
        	operation = operations[index];
        	
        	operation.setStarted();
        	
        	//if(index == operations.length -1) {	//last operation	        		
        	if(operation.action == 'syncAll') {	
        		onOperationComplete = function(operation) {		        	
		                var exception = operation.hasException();
		
		                if (exception) {	                    
		                	batch.exception = true;
                    		batch.exceptions.push(operation);
		                    batch.fireEvent('exception', batch, operation);		                    
		                }
		                
	                	 if (exception && batch.getPauseOnException()) {
		                    batch.pause();
		                } else {
		                    //operation.setCompleted();
		                    batch.fireEvent('operationcomplete', batch, operation);
		                }
			        	
		                batch.fireEvent('complete', batch, operation);	//strore refresh 및 콜백처리
		            };
        	} else {	//per operation 
        		onOperationComplete = function(operation) {		        	
		                var exception = operation.hasException();
		
		                if (exception) {	                    
		                	batch.exception = true;
                    		batch.exceptions.push(operation);
		                    batch.fireEvent('exception', batch, operation);		                    
		                }
		                
	                	 if (exception && batch.getPauseOnException()) {
		                    batch.pause();
		                } else {
		                    //operation.setCompleted();
		                    batch.fireEvent('operationcomplete', batch, operation);
		                }		                
		                
//		                if(operation.action == 'syncAll') {
//		                	batch.fireEvent('complete', batch, operation);
//		                }
		         };
        	}
        	operation.setInternalCallback(onOperationComplete);
            operation.setInternalScope(batch);
        	
        	
        	//proxy.doRequest 소스부
        	if (!me.methodsResolved) {
	            me.resolveMethods();
	        }
	        
        	request = me.buildRequest(operation);
	
	        action  = request.getAction();
	        api     = me.getApi();
	
	        if (api) {
	            fn = api[action];
	        }
	        
	        fn = fn || me.getDirectFn();
	        
	        //<debug>
	        if (!fn) {
	            Ext.Error.raise('No Ext.Direct function specified for this proxy');
	        }
	        //</debug>
	        
	        writer = me.getWriter();
	
	        if (writer && operation.allowWrite()) {
	            request = writer.write(request);
	        }
	
	        // The weird construct below is due to historical way of handling extraParams;
	        // they were mixed in with request data in ServerProxy.buildRequest() and were
	        // inseparable after that point. This does not work well with CUD operations
	        // so instead of using potentially poisoned request params we took the raw
	        // JSON data as Direct function argument payload (but only for CUD!). A side
	        // effect of that was that the request metadata (extraParams) was only available
	        // for read operations.
	        // We keep this craziness for backwards compatibility.
	        if (action === 'read') {
	            params = request.getParams();
	        }
	        else {
	            params = request.getJsonData();
	        }
	
	        
	        
	        
	        
        	
        	
        	args = fn.directCfg.method.getArgs({
	            params: params,
	            paramOrder: me.getParamOrder(),
	            paramsAsHash: me.getParamsAsHash(),
	            metadata: me.getMetadata(),
	            callback: me.createRequestCallback(request, operation),
	            scope: me
	        });
	        
	        request.setConfig({
	            args: args,
	            directFn: fn
	        });
		    			
	        //args.push(me.createRequestCallback(request, operation, onProxyReturn, scope), me);
	        
	        fn.apply(window, args);	       
        }
    },
    
     /**
      * 추가/수정/삭제된 데이타를 server와 동기화 한다.
      * @return {}
      */
    syncAll: function(options) {
    	console.log("Proxy syncAll: ", options);

    	var me = this,
            callback,
            operations = [],
            records,
            batch,
            actions, aLen;
       
        options.batch = {
            proxy: me,
            listeners: options.listeners || {}
        };    
        batch = new Ext.data.Batch(options.batch);
        batch.on('complete', Ext.bind(me.onBatchComplete, me, [options], 0));	//store의 refresh 및 callback 이 처리됨
        
    	actions = me.getBatchOrder().split(',');
        aLen    = actions.length;
		
        if(aLen > 0) {
        	batch.add(me.createOperation('syncAll', {
                records : (options.params ? options.params : [{}]),
                // Relay any additional params through to the Operation (and Request).
                params: [{}]
            }));
        }
        
        for (a = 0; a < aLen; a++) {
            action  = actions[a];
            records = options.operations[action];

            if (records) {            	
            	batch.add(me.createOperation(action, {
                    records : records,
                    // Relay any additional params through to the Operation (and Request).
                    params: options.params
                }));
            }
        }
        
        me.doRequestSyncAll(batch, me);

    }
    
    /**
     * @overide
     * 
     * @param {} options
     * @param {} listeners
     * @return {}
     */
    /*batch: function(options,  deprecated listeners) {
    	console.log("new batch :" , options);
        var me = this,
            useBatch = me.batchActions,
            batch,
            records,
            actions, aLen, action, a, r, rLen, record;

        if (options.operations === undefined) {
            // the old-style (operations, listeners) signature was called
            // so convert to the single options argument syntax
            options = {
                operations: options,
                listeners: listeners
            };
        }

        if (options.batch) {
            if (Ext.isDefined(options.batch.runOperation)) {
                batch = Ext.applyIf(options.batch, {
                    proxy: me,
                    listeners: {}
                });
            }
        } else {
            options.batch = {
                proxy: me,
                listeners: options.listeners || {}
            };
        }

        if (!batch) {
            batch = new Ext.data.Batch(options.batch);
        }

        batch.on('complete', Ext.bind(me.onBatchComplete, me, [options], 0));

        actions = me.batchOrder.split(',');
        aLen    = actions.length;

        for (a = 0; a < aLen; a++) {
            action  = actions[a];
            records = options.operations[action];

            if (records) {
                if (useBatch) {
                    batch.add(new Ext.data.Operation({
                        action  : action,
                        records : records
                    }));
                } else {
                    rLen = records.length;

                    for (r = 0; r < rLen; r++) {
                        record = records[r];

                        batch.add(new Ext.data.Operation({
                            action  : action,
                            records : [record]
                        }));
                    }
                }
            }
        }

        batch.start();
        return batch;
    }*/

}); // Ext.define