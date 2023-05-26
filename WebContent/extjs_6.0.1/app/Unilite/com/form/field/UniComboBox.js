//@charset UTF-8
// http://stackoverflow.com/questions/18390041/extjs-combobox-dynamic-json-updates

Ext.override(Ext.view.BoundListKeyNav, {
	onKeySpace: function() {
        /*if (this.navigateOnSpace) {
            this.callParent(arguments);
        }
        // Allow to propagate to field
        return true;*/
	/*	var e = arguments[0];
		//this.onKeyEnter(e);
		var selModel = this.view.getSelectionModel(),
            field = this.view.pickerField,
            count = selModel.getCount();

        

        // Handle the case where the highlighted item is already selected
        // In this case, the change event won't fire, so just collapse
        if (!field.multiSelect && count === selModel.getCount()) {
            field.collapse();
        }*/
        
        var e = arguments[0];
        var field = this.view.pickerField;
        
        var checkSearchField =  (field && field.up() && Ext.isDefined(field.up().getXType()) &&  field.up().getXType() == 'searchcontainer') ? true:false;
        
        if(!checkSearchField)	{
        	this.selectHighlighted(e);
	        if(field && field.getValue())	{
	        	field.setValue(field.getValue().trim()); //IE 에서 space가 필드에 입력되는 현상이 있음
	        }
			this.onKeyEnter(e);
        }
        
        //다음 필드로 포커스 이동
//		var combo = this.view.ownerCmp;
//		if(combo && combo instanceof Ext.form.field.Text) {
//			Unilite.focusNextField(combo, false, e);
//		}
    },
	highlightAt:function (index) {
        var boundList = this.boundList,
        item = boundList.all.item(index);
        if (item) {
            item = item.dom;
            boundList.highlightItem(item);
            boundList.getTargetEl().scrollChildIntoView(item, true);
            var combo =  this.view.pickerField;
            combo.setValue(boundList.getNode(index).textContent);
        }
    }

});


Ext.override(Ext.form.field.ComboBox, {
	/**
	 * displayField 와 valueField 에서 모두 검색되어지도록 함.
	 * @param {} queryPlan
	 */
	doLocalQuery: function(queryPlan) {
		console.log('doLocalQuery');
        var me = this,
            queryString = queryPlan.query,
            filters = me.getStore().getFilters(),
            filter = me.queryFilter;

        me.queryFilter = null;
        me.changingFilters = true;
        filters.beginUpdate();
        if (filter) {
            filters.remove(filter);
        }
	
        // Querying by a string...
//        if (queryString) {	// 5.1 bug: queryString 이 empty일 경우에도 filter를 태워서 전체 리스트가 보여지도록 함.
            filter = me.queryFilter = new Ext.util.Filter({
                id: me.id + '-filter',
                anyMatch: me.anyMatch,
                caseSensitive: me.caseSensitive,
                root: 'data',
                //property: me.displayField,
                property: (me.searchField ? me.searchField : me.displayField),	// combo에 정의한 searchField 에서 검색되어지도록 한다.
                value: me.enableRegEx ? new RegExp(queryString) : queryString
            });
            filters.add(filter);
//        }
        filters.endUpdate();
        me.changingFilters = false;

        // Expand after adjusting the filter if there are records or if emptyText is configured.
        if (me.store.getCount() || me.getPicker().emptyText) {
            me.expand();
        } else {
            me.collapse();
        }

        me.afterQuery(queryPlan);
    }
});

 /**
  * Unilite용 Combobox
  */
Ext.define('Unilite.com.form.field.UniComboBox', {
    extend: 'Ext.form.field.ComboBox',
    alias: 'widget.uniCombobox',
    requires: [ 
    			'Ext.view.BoundListKeyNav',
    			'Ext.data.Store'/*,
    			'Unilite.com.form.field.UniClearButton'*/
    ],
    mixins: {
        uniBaseField: 'Unilite.com.form.field.UniBaseField' /* ,
        bindable: 'Ext.util.StoreHolder'*/ //'Ext.util.Bindable'      
    },
    //editable: false,
    /**
     * @cfg {boolean} typeAhead
     */
	typeAhead: false ,	
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
    collapseOnSelect: true,
    selectOnTab: true,
    autoSelect: false,
    
//    growToLongestValue: true,
    matchFieldWidth: false,    
    
    //user config
    comboType: '',
    comboCode: '',
    includeMainCode:false,
    childCombo: null,
    
    valueWidth: 0,		// default :0 기분 css에 정의된사이즈
    //abstract function
    onAfterRender	: Ext.emptyFn,
	onStoreLoad		: Ext.emptyFn,
	//onBeforeChange	: Ext.emptyFn,
	onChangeDivCode	: Ext.emptyFn,
	
    constructor : function(config){    
        var me = this;
       	
        var displayField 	= config.displayField || 'text';//this.displayField;
        var valueField 		= config.valueField || this.valueField;
        var valueCss = "uni_combo_value";
        if(me.config.includeMainCode)	{
			valueCss = "uni_combo_value_wide";
        } else if(Ext.isDefined(config.valueWidth) && config.valueWidth > 32)	{
        	valueCss = 'uni_combo_value_none_width';
        }
		
        var valueStyle = '';
        if(Ext.isDefined(config.valueWidth) && config.valueWidth > 32)	{
        	valueStyle = 'style="width:'+config.valueWidth+'px;"';
        }
        Ext.apply(me, {tpl: Ext.create('Ext.XTemplate',
	        '<tpl for=".">',
	            '<div class="x-boundlist-item" style="white-space: nowrap;"><div class="uni_combo_text">{'+displayField+'}</div> <div class="'+valueCss+'" '+valueStyle+'>{'+valueField+'}</div> </div>',	
	        '</tpl>'
	    )});
        // boundlist resizeable
//        Ext.apply(me, 
//        	{listConfig: { resizable: true } }
//        );
	    
        if (config) {
            Ext.apply(me, config);
        }
        
        
//        if(this.allowBlank && !me.readOnly && !me.disabled) {	 		
//	 		this.getTriggers.clear = {
//					type: 'clear',
//					hideWhenMouseOut: true,
//					hideWhenEmpty: true
//				};
//	 	};
 
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
	 		if(this.store.isLoaded()) {
		 		// 하나의 화면에 여러 combo가 하나의 store를 사용할떄 filter문제가 발생하므로 Store를 복제 하여 사용 
		 		store = this._storeClone(this.store);
	 		}else{
	 			store = this.store;
	 		}
	 		Ext.apply(this, {
	            store: store
	        });
	        console.log("combo init: store clone ", me.name, store);
	 	}
	 	
	 	var displayField 	= me.displayField || 'text';//this.displayField;
        var valueField 		= me.valueField;
        var valueCss = "uni_combo_value";
	 	if(me.includeMainCode)	{
			valueCss = "uni_combo_value_wide";
        }else if(Ext.isDefined(me.valueWidth) && me.valueWidth > 32)	{
        	valueCss = 'uni_combo_value_none_width';
        }
		
        var valueStyle = '';
        if(Ext.isDefined(me.valueWidth) && me.valueWidth > 32)	{
        	valueStyle = 'style="width:'+me.valueWidth+'px;"';
        	
        }
        
        Ext.apply(me, {tpl: Ext.create('Ext.XTemplate',
	        '<tpl for=".">',
	            '<div class="x-boundlist-item" style="white-space: nowrap;"><div class="uni_combo_text">{'+displayField+'}</div> <div class="'+valueCss+'" '+valueStyle+' >{'+valueField+'}</div> </div>',	
	        '</tpl>'
	    )});
	 	//triggers 로 변경. 5.0.1
//	 	if(this.allowBlank && !me.readOnly && !me.disabled) {	 		
//    		//this.trigger2Cls = 'x-form-clear-trigger';
//	 		if(!Ext.isDefined(this.plugins)) {
//				this.plugins = new Array();		
//			}
//			this.plugins.push('uniClearbutton');
//	 	};
	 	


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
         //addEvents 제거 - 5.0.1 deprecated
//        me.addEvents("beforechange");
//        me.addEvents("changedivcode");
        
        //me.on("beforechange", 	me.onBeforeChange, me);
        me.on("changedivcode", 	me.onChangeDivCode, me);
        
        // child combo 처리
        me.on('afterrender', function(combo, eOpts) { me._onAfterRender(combo);}); 
        
        
        // 다단계 Combo 처리를 change에서 child를 바꾸는 방식에서 query날리기전 filtering 하는 방식으로 변경
        // form, grid 모두 적용 가능 / 2014.08.13 ksj
        //grid 에서 parent 가 바뀌어도 child 값이 남아 있어 dirtychange 이벤트 추가 / 2015.05.05
        me.on("beforequery", me.onBeforequery, me);    
        me.on('dirtychange', me._onDirtychange, me);

        me.on('expand', me._onExpand, me);
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
	
	    Ext.each (source.getRange(), function (record) {
	        var newRecordData = Ext.clone (record.copy().data);
	        //var model = new source.model (newRecordData, newRecordData.id);
	        var model = new source.model (newRecordData, newRecordData.session);
	
	        target.add (model);
	    });
	
	    return target;
    },    
    _getStore:function(forceRemote) {
    	var me = this;
    	var storeId = "CBS_"+this.comboType+"_"+Unilite.nvl(this.comboCode,'');
    	if(me.includeMainCode)	{
    		storeId = "CBS_MAIN_"+this.comboType+"_"+Unilite.nvl(this.comboCode,'');
    	}
    	var mStore =	Ext.data.StoreManager.lookup(storeId)
    	
    	if (! Ext.isDefined(mStore) ) { //typeof mStore === "undefined" ) {
    		console.log('_getStore from remote ', storeId, mStore);
    		console.log('_getStore comboType, comboCode ', this.comboType, this.comboCode);
    		if(this.comboType && this.comboCode) {
	    		mStore= Ext.create('Ext.data.Store', { 
			        autoLoad: true, 
			        fields: ['value', 'text', 'option', 'search', 'includeMainCode'],
			        sorters: [{
				        property: 'value',
				        direction: 'ASC' // or 'ASC'
				    }],
			        proxy: { 
			            type: 'ajax', 
			            url: CPATH+'/com/getComboList.do?comboType='+this.comboType+'&comboCode='+this.comboCode+"&includeMainCode="+this.includeMainCode
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
		me.getEl().on("click", function(event, elm, eOpt){
						var combo = me;
						console.log("elm.value :",elm.value);
						console.log("event.target.value :",event.target.value);
						if(Ext.isDefined(elm.value) && elm.value=="")	{
							combo.setValue("");
						}
		});
		if(this.child || me.parentNames) {
			if(this.child)	{
				this.childCombo = combo.ownerCt.getComponent(this.child);
				// 2. 없다면 name으로 조회 , grid에서는 ownerForm이 없음.
				if(! this.childCombo &&  combo.ownerForm ) {
					this.childCombo = combo.ownerForm.getField(this.child);
				}
				if(me.childCombo){
					me.childCombo.parentFieldName = me.name;
				}
			}
			//console.log("haschild:" + this.child + " : ", this.childCombo);
			if(me.childCombo || me.parentNames) {
				
				// 값이 바뀌면 child 값을 reset !
				me.on('change', function(combo, newValue, oldValue, eOpts) {	
					if(combo.childCombo) {
						combo.childCombo.clearValue();
					}
					var editIndex ;
					if(combo.ownerCt.grid)	{
					 	editIndex= combo.ownerCt.grid.getStore().indexOf(combo.up('grid').uniOpt.currentRecord);
					}
					if(combo.parentNames && newValue && (combo.ownerCt.grid || (combo.ownerForm && !combo.ownerForm.uniOpt.inLoading)))	{
						switch(this.levelType)	{
							case 'ITEM' :
								UniliteComboServiceImpl.getItemLevelInfo({'LEVEL3':newValue}, function(response,provider){
										if(!Ext.isEmpty(provider.result) && provider.result == 0) {
											Ext.each(combo.parentNames, function(item, idx){
												if( combo.ownerForm ) {
													var pValue = combo.ownerForm.getValue(item);
													if(Ext.isEmpty(pValue)) {
														combo.clearValue();
													}
												}
											});
											return false;

										} else {
											var pLength = combo.parentNames.length;
											Ext.each(combo.parentNames, function(item, idx){
												if(combo.ownerForm ) {
													//var field = combo.ownerForm.getField('LEVEL'+(idx+1));
													var field = combo.ownerForm.getField(item);
													field.store.clearFilter();
													field.queryFilter = null;	
													if(pLength == (idx+1))	combo.ownerForm.setValue(item, provider.result[0]['LEVEL'+(idx+1)], true);	// 소분류 clearfilter 안되도록 설정
													else 					combo.ownerForm.setValue(item, provider.result[0]['LEVEL'+(idx+1)], false);
													
												}else if(combo.ownerCt.grid){
													//var field = combo.ownerCt.grid.getComponent(item);
													//field.store.clearFilter();
													//field.queryFilter = null;	
													var record = combo.ownerCt.grid.getStore().getAt(editIndex);
													record.set(item, provider.result['LEVEL'+(idx+1)]);
												}
											});
											if(Ext.isEmpty(combo.getValue()))	{
												combo.setValue(newValue);
											}
											//combo.setValue(newValue);
										}
								})
								break;
							default:
								break;
						}
					}
				}, this);
			}
		}
		this.onAfterRender(combo);
	},	
	_onDirtychange:function(combo) {
		var me = this;
		
		if(this.child) {
			if(combo.ownerCt.grid)	{
				//this.childCombo = combo.ownerCt.getComponent(this.child);
				this.childCombo = combo.ownerCt.ownerCmp.getColumn(this.child);
			}
			// 2. 없다면 name으로 조회 , grid에서는 ownerForm이 없음.
			if(! this.childCombo &&  combo.ownerForm ) {
				this.childCombo = combo.ownerForm.getField(this.child);
			}
			//console.log("haschild:" + this.child + " : ", this.childCombo);
			if(me.childCombo) {
				me.childCombo.parentFieldName = me.name;
				// 값이 바뀌면 child 값을 reset !
				
				if(combo.childCombo.ownerCt.grid) {		// grid 경우
					//combo.childCombo.editor.clearValue();
					var record = combo.ownerCt.grid.getSelectionModel().getSelection();
					if(record && record.length > 0 ) record[0].set(this.child, '');
					//combo.childCombo.editor.startEdit(combo.childCombo.editor.getEl());
				} 
			}
		}
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
	_onExpand: function(combo) {
		var picker = combo.getPicker();
		var me = this;
		var valueSize = 0;
		if(me.valueWidth > 32)	{	// value part default size : 32
			valueSize = me.valueWidth - 32;
		}
		if(combo.pickerWidth)	{
			picker.setWidth(combo.pickerWidth);
			picker.setBorder( 1 );
		}else {
			//var growLen = combo.getGrowWidth().length - 10;
			var growLen = combo.getGrowWidth().length - ((combo.getEl().getWidth()-32)/14);
			
			if(growLen > 0) { 
				if(combo.ownerForm)	{
					picker.setWidth(combo.bodyEl.getWidth() + (growLen*14)+valueSize);
					picker.setBorder( 1 );
					
				}else {
					picker.setWidth(combo.bodyEl.getWidth() + (growLen*14)+10 + valueSize);
					picker.setBorder( 1 );
				}
			}else{
				picker.setWidth(combo.bodyEl.getWidth()+32 + valueSize);
			}
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
    		if( Ext.isDefined(combo.parentNames) &&  Ext.isEmpty(pValue))	{
    			combo.store.clearFilter();
    			combo.queryFilter = null;	
    		}else if(!Ext.isEmpty(pValue) ) {
				//combo.store.clearFilter(true);
				//combo.queryFilter = null;				//key 입력 필터를 클리어한다. (doLocalQuery에서 queryFilter 를 재생성하도록)
				combo.store.filter('option', pValue);	//Parent 필드값으로 필터를 설정
				return true;
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
    //beforechange 제거하면서 삭제
//    setValue: function(value, doSelect) {
//        var me = this,
//            valueNotFoundText = me.valueNotFoundText,
//            inputEl = me.inputEl,
//            oldValue = me.getValue(),
//            i, len, record,
//            dataObj,
//            matchedRecords = [],
//            displayTplData = [],
//            processedValue = [];
//		
//        if (me.store.loading) {         
//            me.value = value;
//            me.setHiddenValue(me.value);
//            return me;
//        }
//
//        if(this.multiSelect && typeof value === 'string' && value.indexOf(this.delimiter.trim()) > -1 ) {
//        	value = value.split(this.delimiter.trim());
//        }else{
//        	value = Ext.Array.from(value);
//        }
//        for (i = 0, len = value.length; i < len; i++) {
//            record = value[i];
//            if (!record || !record.isModel) {
//                record = me.findRecordByValue(record);
//            }
// 
//            if (record) {
//                matchedRecords.push(record);
//                displayTplData.push(record.data);
//                processedValue.push(record.get(me.valueField));
//            }
//            else {
//                if (!me.forceSelection) {
//                    processedValue.push(value[i]);
//                    dataObj = {};
//                    dataObj[me.displayField] = value[i];
//                    displayTplData.push(dataObj);
//                }
//                else if (Ext.isDefined(valueNotFoundText)) {
//                    displayTplData.push(valueNotFoundText);
//                }
//            }
//        }
//
//        me.setHiddenValue(processedValue);
//        me.value = me.multiSelect ? processedValue : processedValue[0];
//        if (!Ext.isDefined(me.value)) {
//            me.value = null;
//        }
//        
//         //beforechange 추가
//        if(me.fireEvent('beforechange', me, me.value, oldValue) == false) {
//        	return me;	
//        }
//        
//        me.displayTplData = displayTplData;
//        me.lastSelection = me.valueModels = matchedRecords;
//
//        if (inputEl && me.emptyText && !Ext.isEmpty(value)) {
//            inputEl.removeCls(me.emptyCls);
//        }
//
//        me.setRawValue(me.getDisplayValue());
//        me.checkChange();
//
//        if (doSelect !== false) {
//            me.syncSelection();
//        }
//        me.applyEmptyText();
//
//        return me;
//    },
    //override
    //5.0.1 에서는 onBlur 참조하여 필요 시 수정
//    beforeBlur: function(){	//값을 직접 지웠을 때 clear 될 수 있도록  (forceSelection: true 설정과 상관없이 동작하도록)
//        var value = this.getRawValue();
//        if(value == ''){
//            this.lastSelection = [];
//        }
//        this.doQueryTask.cancel();
//        this.assertValue();
//    },
    //override
	setError: function(error){
		var me = this,
            msgTarget = me.msgTarget,
            prop;
            
        if (me.rendered) {
            if (msgTarget == 'title' || msgTarget == 'qtip') {
                prop = msgTarget == 'qtip' ? 'data-errorqtip' : 'title';
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
		
	},
	divFilterByRefCode: function(refCodeName, filterValue, divCode) {		//화면 초기에 열릴때 해당 사업장의 영업담당 or 수불담당 필터처리 위해..
		var me = this;		
		//var pValue = null;
		//var parentField = eOpts.parent;
		if(!Ext.isEmpty(filterValue)) {
			if(me.up('form')) {	// form일경우 (filter 중복 가능)	
				var filterId = divCode;
				
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
