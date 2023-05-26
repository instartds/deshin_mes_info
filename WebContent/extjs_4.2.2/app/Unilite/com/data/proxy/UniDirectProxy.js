//@charset UTF-8


Ext.override(Ext.data.proxy.Server, {
    // Should this be documented as protected method?
	timeout:300000,
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
    
});

/**
 * unilite용 proxy class
 */
Ext.define('Unilite.com.data.proxy.UniDirectProxy', {
	extend: 'Ext.data.proxy.Direct',
    alias: 'proxy.uniDirect',
    batchActions:true,
	writer:'uniWriter',

    requires: ['Ext.direct.Manager'],
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
            writer = me.getWriter(),
            request,
            operation,
            onProxyReturn,
            params,            
            args,
            fn, method;
        
        for(var index=0; index< operations.length; index++) {
        	args = [];
        	operation = operations[index];
        	
        	operation.setStarted();
        	
        	request = me.buildRequest(operation);
        	
        	if (!me.methodsResolved) {
	            me.resolveMethods();
	        }
	
	        fn = me.api[request.action] || me.directFn;
	        
	        //<debug>
	        if (!fn) {
	            Ext.Error.raise('No direct function specified for this proxy');
	        }
	        //</debug>
	
	        if (operation.allowWrite()) {	        	
	            request = writer.write(request);	        	
	        }
	
	        if (operation.action == 'read') {
	            // We need to pass params
	            method = fn.directCfg.method;
	            params = request.params
	            args = method.getArgs(params, me.paramOrder, me.paramsAsHash);
	        } else {
	            args.push(request.jsonData);
	        }
	
	        Ext.apply(request, {
	            args: args,
	            directFn: fn
	        });
	        
	        
	        
        	if(index == operations.length -1) {	//last operation	        		
        		
        		onProxyReturn = function(operation) {		        	
		                var hasException = operation.hasException();
		
		                if (hasException) {	                    
		                	batch.hasException = true;
                    		batch.exceptions.push(operation);
		                    batch.fireEvent('exception', batch, operation);		                    
		                }
		                
	                	 if (hasException && batch.pauseOnException) {
		                    batch.pause();
		                } else {
		                    operation.setCompleted();
		                    batch.fireEvent('operationcomplete', batch, operation);
		                }
			        	
		                batch.fireEvent('complete', batch, operation);	//strore refresh 및 콜백처리
		            };
        	} else {	//per operation 
        		onProxyReturn = function(operation) {		        	
		                var hasException = operation.hasException();
		
		                if (hasException) {	                    
		                	batch.hasException = true;
                    		batch.exceptions.push(operation);
		                    batch.fireEvent('exception', batch, operation);		                    
		                }
		                
	                	 if (hasException && batch.pauseOnException) {
		                    batch.pause();
		                } else {
		                    operation.setCompleted();
		                    batch.fireEvent('operationcomplete', batch, operation);
		                }		                
		                
//		                if(operation.action == 'syncAll') {
//		                	batch.fireEvent('complete', batch, operation);
//		                }
		         };
        	}
		    			
	        args.push(me.createRequestCallback(request, operation, onProxyReturn, scope), me);
	        
	        fn.apply(window, args);	       
        }
    },
    
     /**
      * 추가/수정/삭제된 데이타를 server와 동기화 한다.
      * @return {}
      */
    syncAll: function(options) {
    	console.log("Proxy syncAll(options)");

    	var me = this,
            callback,
            operations = [],
            records,
            batch,
            actions, aLen;
       
        //options.params = options.params || [];     //Master params info
        
        options.batch = {
            proxy: me,
            listeners: options.listeners || {}
        };    
        batch = new Ext.data.Batch(options.batch);
        batch.on('complete', Ext.bind(me.onBatchComplete, me, [options], 0));	//store의 refresh 및 callback 이 처리됨
        
    	actions = me.batchOrder.split(',');
        aLen    = actions.length;
		
        if(aLen > 0) {
        	 batch.add(new Ext.data.Operation({
                action  : 'syncAll',
                records : (options.params ? options.params : [{}])
                //records : []
            }));
        }
        
        for (a = 0; a < aLen; a++) {
            action  = actions[a];
            records = options.operations[action];

            if (records) {            	
            	batch.add(new Ext.data.Operation({
                    action  : action,
                    records : records
                }));
            }
        }
                 
        //if(options.callback)
        //	callback = options.callbak;
        
        me.doRequestSyncAll(batch, me);

    },
    
    /**
     * @overide
     * 
     * @param {} options
     * @param {} listeners
     * @return {}
     */
    batch: function(options, /* deprecated */listeners) {
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
    }

}); // Ext.define