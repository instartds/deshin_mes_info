//@charset UTF-8
/**
 * 
 */


Ext.define('Unilite.com.state.UniStorageProvider', {

    extend: 'Ext.state.Provider',
    alias: 'state.uniStorage',
    
    
    /**
     * The internal store.
     */
    store: null,



    constructor: function (config) {
        config = config || {};
        var me = this;
        Ext.apply(me, config);

        //if (!me.store) {
        //    me.store = me.buildStore();
        //}
        me.addEvents("statechange");
        me.state = {};
        me.isFirst = true;
        me.mixins.observable.constructor.call(me);
    },

    // Statefull.saveState() 에서 grid의 getState()를 통해 columns 와 storeState(단, grouper, sorter, filter 등이 있을 경우만) 상태값을 가져와서  set 한다.
    // Ext.state.Manager.set(..) 하면 provider 로 set 하게 되어 있음.
    set: function (name, value) {
 		var me = this;
        me.state[name] = value;
        me.fireEvent("statechange", me, name, value);
    },

    
    get: function (name, defaultValue) {
    	var me = this;
    	var rv = typeof me.state[name] == "undefined" ?
            defaultValue : me.state[name];
            console.log("GET : ", name, rv);
        return rv;
    },

    _buildState: function() {

    	var me = this;
    	var row, shtInfo;
    	if( Ext.isDefined(me.store)) {
    	 	me.store.data.each(function(item, index, totalItems ) {
    	 		
    	 		// provider 의 state 에 grid의 id를 키값으로 db에 저장되어 있는 상태정보값을 불러들인다.
    	 		me.state[item.get("id")] = item.get("shtInfo");
    	 		
        		me.fireEvent("statechange", me, item.get("id"), null);
    	 		
    	 		console.log("State rebuild:", me.state.length, item.get("id"), item.get("shtInfo") );
    	 	})
    	 	
    	 	/*
    	 	row = me.store.getById(name);
    	 	if(Ext.isDefined(row)) {
	    	 	shtInfo = row.get('shtInfo');
	    	 	if(Ext.isDefined(shtInfo)) {
		    	 	me.state[name] = shtInfo.shtInfo;
	    	 	}
    	 	}
    	 	*/
    	 }
    },
    clear: function (name) {
        var me = this;
        delete me.state[name];
        me.fireEvent("statechange", me, name, null);
    },
	setStore:function(store) {
		this.store = store;
		this._buildState();
	}
	/*

    buildStore: function () {
        return  Ext.data.StoreManager.lookup('STATE_STORE');
    }
    */
    
});
