//@charset UTF-8
// http://stackoverflow.com/questions/18390041/extjs-combobox-dynamic-json-updates

Ext.override(Ext.form.field.ComboBox, {
	/**
	 * displayField 와 valueField 에서 모두 검색되어지도록 함.
	 * @param {} queryPlan
	 */
	doLocalQuery: function(queryPlan) {
        var me = this,
            queryString = queryPlan.query;

        // Create our filter when first needed
        if (!me.queryFilter) {
            // Create the filter that we will use during typing to filter the Store
            me.queryFilter = new Ext.util.Filter({
                id: me.id + '-query-filter',
                anyMatch: me.anyMatch,
                caseSensitive: me.caseSensitive,
                root: 'data',
                //property: me.displayField
                property: me.searchField	// combo에 정의한 searchField 에서 검색되어지도록 한다.
            });
            me.store.addFilter(me.queryFilter, false);
        }

        // Querying by a string...
        if (queryString || !queryPlan.forceAll) {
            me.queryFilter.disabled = false;
            me.queryFilter.setValue(me.enableRegEx ? new RegExp(queryString) : queryString);
        }

        // If forceAll being used, or no query string, disable the filter
        else {
            me.queryFilter.disabled = true;
        }

        // Filter the Store according to the updated filter
        me.store.filter();

        // Expand after adjusting the filter unless there are no matches
        if (me.store.getCount()) {
            me.expand();
        } else {
            me.collapse();
        }

        me.afterQuery(queryPlan);
    },
	/**
	 * space 키로 선택값 입력
     * @private
     * Enables the key nav for the BoundList when it is expanded.
     */
    onExpand: function() {
        var me = this,
            keyNav = me.listKeyNav,
            selectOnTab = me.selectOnTab,
            picker = me.getPicker();

        // Handle BoundList navigation from the input field. Insert a tab listener specially to enable selectOnTab.
        if (keyNav) {
            keyNav.enable();
        } else {
            keyNav = me.listKeyNav = new Ext.view.BoundListKeyNav(me.inputEl, {
                boundList: picker,
                forceKeyDown: true,
                tab: function(e) {
                    if (selectOnTab) {
                        this.selectHighlighted(e);
                        me.triggerBlur();
                    }
                    // Tab key event is allowed to propagate to field
                    return true;
                },
                enter: function(e){
                    var selModel = picker.getSelectionModel(),
                        count = selModel.getCount();
                        
                    this.selectHighlighted(e);
                    
                    // Handle the case where the highlighted item is already selected
                    // In this case, the change event won't fire, so just collapse
                    if (!me.multiSelect && count === selModel.getCount()) {
                        me.collapse();
                    }
                },
                space: function(e){	//2014.09.04 space 키로 선택값 입력된 후 포커스 이동하도록 수정
                    var selModel = picker.getSelectionModel(),
                        count = selModel.getCount();
                        
                    this.selectHighlighted(e);
                    
                    // Handle the case where the highlighted item is already selected
                    // In this case, the change event won't fire, so just collapse
                    if (!me.multiSelect && count === selModel.getCount()) {
                        me.collapse();
                    }
                    
                    Unilite.focusNextField(me, false, e);
                }
            });
        }

        // While list is expanded, stop tab monitoring from Ext.form.field.Trigger so it doesn't short-circuit selectOnTab
        if (selectOnTab) {
            me.ignoreMonitorTab = true;
        }

        Ext.defer(keyNav.enable, 1, keyNav); //wait a bit so it doesn't react to the down arrow opening the picker
        //me.inputEl.focus();
        
    }
});

 /**
  * Unilite용 Combobox
  */
Ext.define('Unilite.com.form.field.UniComboBox', {
    extend: 'Ext.form.field.ComboBox',
    alias: 'widget.uniCombobox',
    requires: [ 
    			'Ext.data.Store',
    			'Unilite.com.form.field.UniClearButton'
    ],
    mixins: {
        uniBaseField: 'Unilite.com.form.field.UniBaseField'  ,
        bindable: 'Ext.util.Bindable'      
    },
    //editable: false,
    /**
     * @cfg {boolean} typeAhead
     */
	typeAhead: true ,	
    queryMode: 'local', 
    /**
     * @cfg {Boolean} forceSelection
     */
    forceSelection: true,   
    /**
     * 
     * @cfg {Boolean} anyMatch
     * 
     * true:검색시 중간에 포함 되어도 검색 되게 함
     * false : 첫문자 부터 검색
     */
    anyMatch:true,
    /**
     * 
     * @cfg {String} displayField
     */
	displayField: 'text',
	/**
     * 
     * @cfg {String} valueField
     */
    valueField: 'value',
    
    searchField: 'search',
    
    store: undefined,
    withOptionValue: false,
    selectOnTab: true,        
    
//    tpl : Ext.create('Ext.XTemplate',
//        '<tpl for=".">',
//            //'<div class="x-boundlist-item">{value} | {text}</div>',
//            '<div class="x-boundlist-item"><div class="uni_combo_text">{text}</div> <div class="uni_combo_value">{value}</div> </div>',	
//        '</tpl>'
//    ),	
    
    //user config
    comboType: '',
    comboCode: '',
    childCombo: null,
    
    //abstract function
    onAfterRender	: Ext.emptyFn,
	onStoreLoad		: Ext.emptyFn,
	onBeforeChange	: Ext.emptyFn,
	onChangeDivCode	: Ext.emptyFn,
    
    constructor : function(config){    
        var me = this;

        var displayField 	= config.displayField || this.displayField;
        var valueField 		= config.valueField || this.valueField;
        Ext.apply(me, {tpl: Ext.create('Ext.XTemplate',
	        '<tpl for=".">',
	            '<div class="x-boundlist-item"><div class="uni_combo_text">{'+displayField+'}</div> <div class="uni_combo_value">{'+valueField+'}</div> </div>',	
	        '</tpl>'
	    )});
        
        if (config) {
            Ext.apply(me, config);
        }
        
 
        this.callParent([config]);
	}, // constructor
	initComponent: function () {
		var me = this;
		if (this.fieldLabel) {
			//this.emptyText = this.fieldLabel + '을(를) 선택하세요' 
		};
		var store;
	 	if (typeof this.store === "undefined") { // 공통코드 Store
	 		store = this._getStore();
	 		Ext.apply(this, {
	            store: store
	        });
	        //console.log("combo init: _getStore ", store);
	 	} else { 								// Controller 에서 정의된 Store clone 
	 		// 하나의 화면에 여러 combo가 하나의 store를 사용할떄 filter문제가 발생하므로 Store를 복제 하여 사용 
	 		store = this._storeClone(this.store)
	 		Ext.apply(this, {
	            store: store
	        });
	        console.log("combo init: store clone ", me.name, store);
	 	}
	 	
	 	if(this.allowBlank && !me.readOnly && !me.disabled) {	 		
    		//this.trigger2Cls = 'x-form-clear-trigger';
	 		if(!Ext.isDefined(this.plugins)) {
				this.plugins = new Array();		
			}
			this.plugins.push('uniClearbutton');
	 	};
	 	


//	 	var combineFilter = new Ext.util.Filter({
//	        filterFn : function(record) {
//	        	var t = new String(record.get(me.displayField));
//    			var v = new String(record.get(me.valueField));
//    			var searchValue = me.getValue();
//    			if(searchValue != null) {
//    				searchValue = searchValue.toLowerCase();
//    			} else {
//    				searchValue = null;
//    			}
//	        	return t.toLowerCase().indexOf(searchValue) == 0 ||
//        				v.toLowerCase().indexOf(searchValue) == 0;			       
//	        } // filterFn
//        });
        
         //beforechange 추가
        me.addEvents("beforechange");
        me.addEvents("changedivcode");
        
        me.on("beforechange", 	me.onBeforeChange, me);
        me.on("changedivcode", 	me.onChangeDivCode, me);
        
        // child combo 처리
        me.on('afterrender', function(combo, eOpts) { me._onAfterRender(combo);});        

        // 다단계 Combo 처리를 change에서 child를 바꾸는 방식에서 query날리기전 filtering 하는 방식으로 변경
        // form, grid 모두 적용 가능 / 2014.08.13 ksj
        me.on("beforequery", me.onBeforequery, me);
        
        me.on('expand', me._onExpand, me);
        
//        this.on('specialkey', function(elm, e){
//    		switch( e.getKey() ) {    			
//            case Ext.EventObject.ENTER:
//            	if(e.shiftKey && !e.ctrlKey && !e.altKey) {
//            		Unilite.focusPrevField(elm);
//            	}else if(!e.shiftKey && !e.ctrlKey && !e.altKey){
//            		Unilite.focusNextField(elm);
//            	}
//            	break;
//  			}      
//    	});

        /*
		me.on('beforequeryX',function(queryPlan) {
				console.log("queryPlan", queryPlan);
				var me = this;
				var searchValue = me.getValue();
				//me.store.clearFilter();  // combo child와 문제 발생 2014.02.13 / beforequery를 수행 하는 이유는? 
				if(!queryPlan.forceAll && searchValue != null && searchValue.length > 0 ) {
					//searchValue = searchValue.toLowerCase();
					me.store.filter(combineFilter);
					
			        //me.store.filterBy(function(record) {
			        //	var t = new String(record.get(me.displayField));
            		//	var v = new String(record.get(me.valueField));
            		//	
			        //	return t.toLowerCase().indexOf(searchValue) == 0 ||
                	//			v.toLowerCase().indexOf(searchValue) == 0;
			        //});
			        
			    } else {
		        	return true;
		        }
		    }
		);
		*/
	 	this.callParent();
	},	

	// private
	_storeClone: function(source) {
	    var target = Ext.create ('Ext.data.Store', {
	        model: source.model
	    });
	
	    Ext.each (source.getRange (), function (record) {
	        var newRecordData = Ext.clone (record.copy().data);
	        var model = new source.model (newRecordData, newRecordData.id);
	
	        target.add (model);
	    });
	
	    return target;
    },    
    _getStore:function(forceRemote) {
    	var me = this;
    	var storeId = "CBS_"+this.comboType+"_"+Unilite.nvl(this.comboCode,'');
    	var mStore =	Ext.data.StoreManager.lookup(storeId)
    	
    	if (! Ext.isDefined(mStore) ) { //typeof mStore === "undefined" ) {
    		console.log('_getStore from remote ', storeId, mStore);
    		console.log('_getStore comboType, comboCode ', this.comboType, this.comboCode);
    		if(this.comboType && this.comboCode) {
	    		mStore= Ext.create('Ext.data.Store', { 
			        autoLoad: true, 
			        fields: ['value', 'text', 'option', 'search'],
			        sorters: [{
				        property: 'value',
				        direction: 'ASC' // or 'ASC'
				    }],
			        proxy: { 
			            type: 'ajax', 
			            url: CPATH+'/com/getComboList.do?comboType='+this.comboType+'&comboCode='+this.comboCode
			        },
			        listeners: {
			        	//load: me.onStoreLoad
			        	load: function(store, records, successful, eOpts) {
			        		me.onStoreLoad(me, store, records, successful, eOpts);
			        	}
			        }
			    });
    		}
    	}else{
    		mStore = me._storeClone(mStore);
    		mStore.on({
    			//load: me.onStoreLoad
    			load: function(store, records, successful, eOpts) {
	        		me.onStoreLoad(me, store, records, successful, eOpts);
	        	}
    		});		
    	}
	 	return mStore;
    },       
	
	_onAfterRender:function(combo) {
		var me = this;
		
		if(this.child) {
			this.childCombo = combo.ownerCt.getComponent(this.child);
			// 2. 없다면 name으로 조회 , grid에서는 ownerForm이 없음.
			if(! this.childCombo &&  combo.ownerForm ) {
				this.childCombo = combo.ownerForm.getField(this.child);
			}
			//console.log("haschild:" + this.child + " : ", this.childCombo);
			if(me.childCombo) {
				me.childCombo.parentFieldName = me.name;
				// 값이 바뀌면 child 값을 reset !
				me.on('change', function(combo, newValue, oldValue, eOpts) {	
					if(combo.childCombo) {
						combo.childCombo.clearValue();
					}
				}, this);
			}
		}
		this.onAfterRender(combo);
	},	
//	onAfterRenderX:function(combo) {
//		var me = this;
//		if(this.child) {
//			//var childObj = Ext.getCmp(this.child);
//			//var childObj = combo.ownerCt.getComponent(this.child);
//			// 1. itemId로 조회
//			this.childCombo = combo.ownerCt.getComponent(this.child);
//			// 2. 없다면 name으로 조회 , grid에서는 ownerForm이 없음.
//			if(! this.childCombo &&  combo.ownerForm ) {
//				this.childCombo = combo.ownerForm.getField(this.child);
//			}
//			console.log("haschild:" + this.child + " : ", this.childCombo);
//			if(me.childCombo) {
//				me.childCombo.parentFieldName = me.name;
//				//this.childCombo.store.filter("X","Y"); // 좀더 세련된 방법으로 ㅠㅠ
//		 		me.on('change', function(combo, newValue, oldValue, eOpts) {		 					
//							//var childObj = Ext.getCmp(this.child); //- itemId 사용 권장 
//							//var childObj = combo.ownerForm.getField(this.child);
//		 					console.log("afterRendender onChange. oldValue:" + oldValue + ", newValue:" + newValue);
//							if(combo.childCombo) {
//								combo.childCombo.store.clearFilter(true);
//								combo.childCombo.store.filter('option', newValue);
//								combo.childCombo.clearValue();
//								
////								combo.childCombo.store.clearFilter(true);
////								var filterValue = "";
////								if(combo.parentOptionValue) {
////						      		//filterValue = combo.parentOptionValue+'|'+combo.getValue();
////						      		filterValue = combo.parentOptionValue+'|'+newValue;
////								} else {
////									filterValue =  newValue;
////								}
////								
////								combo.childCombo.store.filter('option', filterValue);
////						      	combo.childCombo.parentOptionValue = newValue;
////						      	combo.childCombo.clearValue();
//							}
//					    },
//					this
//				); // me.on 
//			}
//	 	};
//	},
	getGrowWidth: function () {
        var me = this,
            value = me.inputEl.dom.value,
            field, store, dataLn, currentLongestLength,
            i, item, itemLn;

        if (me.growToLongestValue) {
            field = me.displayField;
            store = me.store;
            dataLn = store.data.length;
            currentLongestLength = 0;

            for (i = 0; i < dataLn; i++) {
                item = store.getAt(i).data[field];
                itemLn = item.length;

                // Compare the current item's length with the current longest length and store the value.
                if (itemLn > currentLongestLength) {
                    currentLongestLength = itemLn;
                    value = item;
                }
            }
        }

        return value;
    },
	_onExpand: function(combo) {
		var picker = combo.getPicker();
		//var growLen = combo.getGrowWidth().length - 10;
		var growLen = combo.getGrowWidth().length - (combo.getEl().getWidth()/10);
		
		if(growLen > 0) { 
			picker.setWidth(combo.bodyEl.getWidth() + (growLen*15));
		}else{
			picker.setWidth(combo.bodyEl.getWidth());
		}
	},
	onBeforequery : function(queryPlan, eOpts) { 
    	var combo = queryPlan.combo
    	// Parent 필드가 있을 경우
    	if ( combo.parentFieldName ) {
    		var parentField=null;
    		var pValue=null;
    		if(combo.ownerForm) {	// form일경우
    			parentField = combo.ownerForm.getField(combo.parentFieldName);
    			
    			if(parentField) {
    				 pValue=parentField.getValue();
    			}
    		}  else {
    			var grid = combo.up('grid');
    			pValue = grid.uniOpt.currentRecord.get(combo.parentFieldName);
    		}
    		if(!Ext.isEmpty(pValue)) {
				combo.store.clearFilter(true);
				combo.queryFilter = null;				//key 입력 필터를 클리어한다. (doLocalQuery에서 queryFilter 를 재생성하도록)
				combo.store.filter('option', pValue);	//Parent 필드값으로 필터를 설정
    		} else {
//        			this.childCombo.store.filter("X","Y");
    			UniUtils.msg('확인','상위 분류값을 먼저 선택해 주세요.');
    			return false;
    		}
        }        	
    },			
	/*
	onTrigger2Click: function (args) {
		console.log("clear");
		this.setValue("");
	},
	*/
	/*
	getSubTplMarkup : function(values) {
        var me = this,
            field = me.callParent(arguments);

        return '<div style="position: relative">H:' + field+'</div>';
    },
    */
	/*
	handler_StoreLoad: function (store, records, successful, option) { 
		if(this.allowBlank) {
			this.store.add({value:'',text:''});
	 	};	 			
	},
	*/
        
    //override
    setValue: function(value, doSelect) {
        var me = this,
            valueNotFoundText = me.valueNotFoundText,
            inputEl = me.inputEl,
            oldValue = me.getValue(),
            i, len, record,
            dataObj,
            matchedRecords = [],
            displayTplData = [],
            processedValue = [];
		
        if (me.store.loading) {         
            me.value = value;
            me.setHiddenValue(me.value);
            return me;
        }

        if(this.multiSelect && typeof value === 'string' && value.indexOf(this.delimiter.trim()) > -1 ) {
        	value = value.split(this.delimiter.trim());
        }else{
        	value = Ext.Array.from(value);
        }
        for (i = 0, len = value.length; i < len; i++) {
            record = value[i];
            if (!record || !record.isModel) {
                record = me.findRecordByValue(record);
            }
 
            if (record) {
                matchedRecords.push(record);
                displayTplData.push(record.data);
                processedValue.push(record.get(me.valueField));
            }
            else {
                if (!me.forceSelection) {
                    processedValue.push(value[i]);
                    dataObj = {};
                    dataObj[me.displayField] = value[i];
                    displayTplData.push(dataObj);
                }
                else if (Ext.isDefined(valueNotFoundText)) {
                    displayTplData.push(valueNotFoundText);
                }
            }
        }

        me.setHiddenValue(processedValue);
        me.value = me.multiSelect ? processedValue : processedValue[0];
        if (!Ext.isDefined(me.value)) {
            me.value = null;
        }
        
         //beforechange 추가
        if(me.fireEvent('beforechange', me, me.value, oldValue) == false) {
        	return me;	
        }
        
        me.displayTplData = displayTplData;
        me.lastSelection = me.valueModels = matchedRecords;

        if (inputEl && me.emptyText && !Ext.isEmpty(value)) {
            inputEl.removeCls(me.emptyCls);
        }

        me.setRawValue(me.getDisplayValue());
        me.checkChange();

        if (doSelect !== false) {
            me.syncSelection();
        }
        me.applyEmptyText();

        return me;
    },
    //override
    beforeBlur: function(){	//값을 직접 지웠을 때 clear 될 수 있도록  (forceSelection: true 설정과 상관없이 동작하도록)
        var value = this.getRawValue();
        if(value == ''){
            this.lastSelection = [];
        }
        this.doQueryTask.cancel();
        this.assertValue();
    },
    //override
	setError: function(error){
		var me = this,
            msgTarget = me.msgTarget,
            prop;
            
        if (me.rendered) {
            if (msgTarget == 'title' || msgTarget == 'qtip') {
                if (me.rendered) {
                    prop = msgTarget == 'qtip' ? 'data-errorqtip' : 'title';
                }
                me.getActionEl().dom.setAttribute(prop, error || '');
            } else {
                //me.updateLayout();
            }
        }
	},
	
	//관련 이벤트 발동 업이 값만 설정
    setValueOnly: function(value, doSelect) {
    	this.suspendEvents(false);
		this.setValue(value, doSelect);
		this.resumeEvents();
    },    
	changeDivCode: function(combo, newValue, oldValue, eOpts) {
		var me = combo;		
		var form = me.ownerForm;
		if(form) {
			var fields = form.getForm().getFields();
			console.log("changeDivCode called by %s of form", me.getName());
			
			for(i = 0, len = fields.length; i < len; i ++) {
				var field = fields.getAt(i);		
				if(field instanceof Ext.form.field.ComboBox) {
					eOpts = eOpts || {};
					eOpts.parent 	= combo;
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);
				}			
			}
		}/*else{
			var grid = me.up('grid');
			for(i = 0, len = grid.columns.length; i < len; i ++) {
				var column = grid.columns[i];
				if(column.editor && column.editor instanceof Ext.form.field.ComboBox) {
					eOpts = eOpts || {};
					eOpts.parent 	= combo;
					//eOpts.context	= grid.getSelectionModel().getCurrentPosition().view.editingPlugin.context;
					column.editor.fireEvent('unidivchange', column.editor, newValue, oldValue, eOpts);
				}
			};
		}*/
	},
	filterByRefCode: function(refCodeName, filterValue, parentField) {
		var me = this;		
		//var pValue = null;
		//var parentField = eOpts.parent;		
		
		
		if(!Ext.isEmpty(filterValue)) {
			if(me.up('form')) {	// form일경우 (filter 중복 가능)	
				var filterId = parentField.name;
				
				me.store.removeFilter(filterId);
				me.queryFilter = null;
				//new 로 생성할 경우 root 설정 필수!!
				var filter = new Ext.util.Filter({id: filterId, property: refCodeName, value: filterValue, root: 'data'});
				//var filter2 = new Ext.util.Filter({id: 'unideptchange', property: 'refCode2', value: '101000', root: 'data'});
				me.store.addFilter([filter]);
				
				me.clearValue();			
			} else {	//grid
				//ToDo : 현재는 clear 하지만 필요하면 중복 필터 처리..
				me.store.clearFilter();
				me.store.filter(refCodeName, filterValue);
			}
		}
		
	}
});
