//@charset UTF-8
/**
 * 초기값 설정 방법
 * value: 'value'
 */
Ext.define('Unilite.com.form.UniRadiogroup', {
    extend: 'Ext.form.RadioGroup',
    alias: 'widget.uniRadiogroup',
    name:'',
    comboType: '',
    comboCode: '',
    curValue: '',
    validateOnChange:true,
    //simpleValue:true,
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
		me.on('afterrender', me._onAfterRender, me, me.event);
	},
	 setReadOnly: function(readOnly) {
        var boxes = this.getBoxes(),
            b,
            bLen  = boxes.length;

        for (b = 0; b < bLen; b++) {
        	boxes[b].readOnlyCls = 'uniRadioReadonly';
            boxes[b].setReadOnly(readOnly);
        }

        this.readOnly = readOnly;
    },
	/**
	 * http://www.sencha.com/forum/showthread.php?187185-Set-a-int-value-on-a-radiogroup-fails&p=986333#post986333
	 * to solve loadRecord
	 * @param {} value
	 */
    /*
	setValue: function (value) {
	    if (!Ext.isObject(value)) {
	        var obj = new Object();
	        obj[this.name] = value;
	        value = obj;
	    }
	    Ext.form.RadioGroup.prototype.setValue.call(this, value);
	} ,*/
	// validate 함수를 타기 위해 변경 (Ext.form.CheckboxGroup)
	getErrors: function() {
		var me = this;
        var errors = [];
        var validator = me.validator;
        if (Ext.isFunction(validator)) {
            msg = validator.call(me, me.value);
            if (msg !== true) {
                errors.push(msg);
            }
        }
        if (!this.allowBlank && Ext.isEmpty(this.getChecked())) {
            errors.push(this.blankText);
        }
        return errors;
    },
	handler_StoreLoad: function (store, mRecords, successful, options) {
		var records = store.data.items, fieldName = this.name;
		//console.log("fieldName:", fieldName, "records:", records);
		//this.removeAll();
		if(store.count() > 0 ) {
			var items = [];		
			if(this.allowBlank) {
				items.push({ boxLabel: UniUtils.getLabel('system.label.commonJS.groupfield.allText','전체') , inputValue: '' , name: fieldName, checked : true});
		 	};	
			for( var i=0, j=records.length; i<j; i++ ){			 		
		 		var item ;
		 		if (this.value == records[i].get('value') ) {
		 			var t = (this.allowBlank) ? false:true;
		 			item = {
				 			boxLabel: records[i].get('text') ,
		            		inputValue: records[i].get('value') ,
		            		name: fieldName,
		            		checked : t
	            		};
            	} else {
            		item = {
				 			boxLabel: records[i].get('text') ,
		            		inputValue: records[i].get('value') ,
		            		name: fieldName
	            		};
            	}
            	
            	//console.log(item);
		 		items.push(item);
			}
			//console.log("done");
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
    },
	_onAfterRender : function(radioGroup, eOpts)	{
		var boxes = this.getBoxes(),
	        b,
	        bLen  = boxes.length;
		var value = radioGroup.getValue()[radioGroup.name];
		if(!Ext.isEmpty(value))	{
		    for (b = 0; b < bLen; b++) {
		    	if(boxes[b].el && boxes[b].el.dom && boxes[b].el.dom.classList )	{
			    	if(    value != boxes[b].inputValue 
			    		&& boxes[b].el.dom.classList.contains('x-form-cb-checked')
			    	  )	{
			    		boxes[b].el.dom.classList.remove('x-form-cb-checked');
			    	} 
		    	}
		    }
		}
	}
});
