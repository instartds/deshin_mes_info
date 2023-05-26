//@charset UTF-8
/**
 * 초기값 설정 방법 : 
 * 1. 각 값으로 설정
 *   value : ['A1','B1']
 * 2. 모두 checked로 시작  
 *   initAllTrue : true
 * 
 */
Ext.define('Unilite.com.form.UniCheckboxgroup', {
    extend: 'Ext.form.CheckboxGroup',
    alias: 'widget.uniCheckboxgroup',
    comboType: '',
    comboCode: '',
    values:[],
    initAllTrue: false,
	initComponent: function () {		
		var me = this;
		this.callParent();
		if(!Ext.isEmpty(me.comboType) && !Ext.isEmpty(me.comboCode)) {
			if (typeof me.store === "undefined") {
				var mstore = me._getStore();
		 		Ext.apply(this, {
		            store: mstore
		        });
		        mstore.on('load', me.handler_StoreLoad, this);
		        me.handler_StoreLoad(me.store);
		 	} else {
		 		me.handler_StoreLoad(me.store);
		 	}
		}
	},
	 setReadOnly: function(readOnly) {
        var boxes = this.getBoxes(),
            b,
            bLen  = boxes.length;

        for (b = 0; b < bLen; b++) {
        	boxes[b].readOnlyCls = 'uniCheckBoxReadonly';
            boxes[b].setReadOnly(readOnly);
        }

        this.readOnly = readOnly;
    },
	handler_StoreLoad: function (store, mRecords, successful, options) {
		var records = store.data.items;
		if(records) {
			var items = [];
			for( var i=0, j=records.length; i<j; i++ ){		
				var item ;
		 		if (this.initAllTrue || Ext.Array.contains(this.values,records[i].get('value') )) {
		 			item = {
				 			boxLabel: records[i].get('text') ,
		            		inputValue: records[i].get('value') ,
		            		name: this.name+'[]',
		            		checked : true
	            		};
            	} else {
            		item = {
				 			boxLabel: records[i].get('text') ,
		            		inputValue: records[i].get('value') ,
		            		name: this.name+'[]'
	            		};
            	}
            	
            	//console.log(item);
		 		items.push(item);
			}
			this.add( items);
		}
	} ,
    // private
    _getStore:function() {
    	var storeId = "CBS_"+this.comboType+"_"+this.comboCode;
    	var mStore =	Ext.data.StoreManager.lookup(storeId)
    	console.log('_getStore : ', storeId, mStore);
    	if ( ! Ext.isDefined(mStore) ) { //typeof mStore === "undefined" ) {
    		mStore= Ext.create('Ext.data.Store', { 
		        autoLoad: true, 
		        fields: ['value', 'text'],
		        sorters: [{
			        property: 'value',
			        direction: 'ASC' // or 'ASC'
			    }],
		        proxy: { 
		            type: 'ajax', 
		            url: CPATH+'/com/getComboList.do?comboType='+this.comboType+'&comboCode='+this.comboCode
		        } 
		    } );
    	}
	 	return mStore;
    }
     
});
