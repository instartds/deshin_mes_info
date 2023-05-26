//@charset UTF-8
/**
 * Unilite용 Direct Store / 데이타 수정이 필요한 곳에만 사용 !
 *  * Sync시 (create, update, delete가 하나의 sync 함수로 통합함)
 */
Ext.define('Unilite.com.data.UniStore', {
    extend: 'Unilite.com.data.UniAbstractStore',
    alias: 'store.uniStore',
    
    requires: [
    	'Ext.data.proxy.Direct', 
    	'Unilite.com.data.UniWriter',
    	'Unilite.com.UniAppManager'
    ],
	
    readParams:{},
	
    constructor: function(config){
    	var me = this;
        config = Ext.apply({}, config);
        
		Ext.apply(config.proxy, {
				//writer:'uniWriter',
				batchActions: true,
				batchOrder : 'destroy,create,update'
		});
		me.callParent(arguments);
        UniAppManager.register(this);   
		Ext.applyIf(this.uniOpt, {state:{btn:{}}});  
    	
        //
   		me.on('update', me._onStoreUpdate, me);
 		me.on('load', me._onStoreLoad, me);
 		me.on('datachanged', me._onStoreDataChanged, me);
        me.on('beforeload', me._onBeforeLoad, me);

    } // initComponent
	, onStoreActionEnable: function(eOpts)	{
		var tmpIsMaster = this.uniOpt.isMaster;
		this.uniOpt.isMaster = true;
		this._onStoreDataChanged(this,eOpts);
		this.uniOpt.isMaster = tmpIsMaster;
	}
    ,_onStoreUpdate: function (store, eOpt) {
    	if(this.uniOpt.isMaster) {
	    	//console.log("Store data updated save btn enabled !");
	    	UniAppManager.setToolbarButtons('save', true);
    	}
    } // onStoreUpdate
    ,_onStoreLoad: function ( store, records, successful, eOpts ) {
    	if(this.uniOpt.isMaster) {
	    	console.log("onStoreLoad");
	    	if (records) {
		    	UniAppManager.setToolbarButtons('save', false);
				var msg = records.length + Msg.sMB001; //'건이 조회되었습니다.';
		    	//console.log(msg, st);
		    	UniAppManager.updateStatus(msg, true);	
	    	}
    	}
    } //onStoreLoad
   
    ,_onStoreDataChanged: function( store, eOpts )	{
    	if(this.uniOpt.isMaster) {
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			UniApp.setToolbarButtons(['delete'], false);
       			if(this.uniOpt.allDeletable){
       				UniApp.setToolbarButtons(['deleteAll'], false);
       			}
	    		Ext.apply(this.uniOpt.state, {'btn':{'delete':false}});
	    		if(this.uniOpt.useNavi) {
	       			UniApp.setToolbarButtons(['prev','next'], false);
	    		}
       		}else {
       			if(this.uniOpt.deletable)	{
	       			UniApp.setToolbarButtons(['delete'], true);
	       			if(this.uniOpt.allDeletable){
	       				UniApp.setToolbarButtons(['deleteAll'], true);
	       			}	       			
		    		Ext.apply(this.uniOpt.state, {'btn':{'delete':true}});
       			}
	    		if(this.uniOpt.useNavi) {
	       			UniApp.setToolbarButtons(['prev','next'], true);
	    		}
       		}
       		if(store.isDirty())	{
       			UniApp.setToolbarButtons(['save'], true);
       		}else {
       			UniApp.setToolbarButtons(['save'], false);
       		}
    	}
    }, 
    _onBeforeLoad:function(store, operation, eOpts)	{
    	var params = operation.getParams();
    	
    	store.readParams = params;
    },
    // onStoreDatachanged
//    _onException:function(proxy, response, operation, eOpts) {
//    	var vMsg = operation.getError() ;
//    	if(response) {
//    		vMsg = vMsg + "<br/>" + response.where
//    	}
//    	
//    	 Ext.MessageBox.show({
//		                    title: 'REMOTE EXCEPTION',
//		                    msg: vMsg,
//		                    icon: Ext.MessageBox.ERROR,
//		                    buttons: Ext.Msg.OK
//		                });
//    },

    
     
    /**
     * 저장할 것이 있는지 확인
     * extjs의 isDirty와 의미가 조금 다름.
     * @return {}
     */
    isDirty: function() {
    	var me = this, needsSync = false;
        var toCreate = me.data.filterBy(function(item) {return item.phantom === true;});
        var toUpdate = me.data.filterBy(function(item) {return item.dirty === true && item.phantom !== true });
        var toDestroy = me.getRemovedRecords();
            

        if (toCreate.length > 0 || toUpdate.length > 0 || toDestroy.length > 0) {
            needsSync = true;
        }
        return needsSync;
    },    
    isUpdateDirty: function() {
    	var me = this, needsSync = false;
        var toUpdate = me.data.filterBy(function(item) {return item.dirty === true && item.phantom !== true });            

        if (toUpdate.length > 0) {
            needsSync = true;
        }
        return needsSync;
    },
    /**
     * 조건식에 의해 컬럼의 합계를 가져온다.
     * @param {} queryFn	query 할 function
     * @param {} sumCols	집계할 컬럼명 배열 객체
     * @return {}	sum된 값을  sumCols의 각 이름으로 리턴
     */
    sumBy: function(queryFn, sumCols) {
    	var records = this.queryBy(queryFn);
		var results = new Array();
		Ext.each(sumCols, function(colName) {
			results[colName] = 0;
			Ext.each(records.items, function(record){
				results[colName] += Ext.isNumeric(record.get(colName)) ? record.get(colName):0;
			});
		});
		return results;
    },
    
    countBy: function(queryFn) {
    	var records = this.queryBy(queryFn);
    	return records.getCount();
    }
    
}); // Ext.define
