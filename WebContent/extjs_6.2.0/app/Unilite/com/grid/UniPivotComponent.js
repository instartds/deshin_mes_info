Ext.define('UniPivotComponent', {
	extend: 'Ext.Component',
	alias: 'widget.UniPivotComponent',
	grid : null,
	store : null,
	scrollable : true,
	flex : 1,
	style : 'background-color : #ffffff;border : 1px #afafaf solid; margin : 5px; padding : 5px;',
	initRows : [],
	initCols : [],
	initVals     : [],
	aggregatorName: "개수",
	rowOrder: "value_a_to_z", 
	colOrder: "value_z_to_a",
    rendererName : '표',
    
    uniOpt : {
    	rows: [],
	    cols: [],
	    vals: [],
	    width : 1000,
	    height : 300,
	    rowOrder: "value_a_to_z", 
	    colOrder: "value_z_to_a",
	    rendererName : '표',
		aggregatorName: "개수",
	    rendererOptions :{
	    	c3: {
				color: {
					pattern: ["#A3629F", "#39799F", "#EEB540", "#83B660", "#9E4B7C", 
						      "#52AFAE", "#E28938", "#6F5B9A", "#319167", "#7D557E", 
						      "#D06356", "#767676", "#348EC9", "#6E8E4A", "#BC6999", 
						      "#2B96A3", "#A87B47", "#8381C6", "#349466", "#3b3eac"]
				}
			}
	    }
    },
    
    constructor: function(config){
    	config = config || {};
    	var uniOpt = Ext.clone(this.uniOpt);
    	var objConfig = new Object();
    	objConfig.uniOpt = uniOpt
    	
    	if(config.store){
    		objConfig.store  = config.store;
        }
    	if(config.initFields) {
        	objConfig.initFields = config.initFields;
        	objConfig.uiComponentId = config.id;
        } else if(config.grid){
    		objConfig.grid  = config.grid;
    		objConfig.uiComponentId = config.grid.getId();
        } else if(config.model){
        	objConfig.model = config.model;
        	objConfig.fieldStore = this.setPivotFieldsStoreWithModel();
        } else if(config.store){
        	objConfig.store = config.store;
        	objConfig.model = config.store.model;
        	objConfig.uiComponentId = config.id;
        } 
    	if(config.initRows){
    		objConfig.initRows  = config.initRows;
    		objConfig.uniOpt.rows  = config.initRows;
        }
    	if(config.initCols){
    		objConfig.initCols  = config.initCols;
    		objConfig.uniOpt.cols  = config.initCols;
        }
    	if(config.initVals){
    		objConfig.initVals  = config.initVals;
    		objConfig.uniOpt.vals  = config.initVals;
        }
    	if(config.rendererOptions){
    		objConfig.uniOpt.rendererOptions  = config.rendererOptions;
        }
    	if(config.aggregatorName){
    		objConfig.uniOpt.aggregatorName  = config.aggregatorName;
    		objConfig.uniOpt.configAggregatorName = config.aggregatorName
        } else {
        	objConfig.uniOpt.configAggregatorName = '';
        }
    	
    	if(config.rendererName){
    		objConfig.uniOpt.rendererName  = config.rendererName;
        }
    	if(config.fieldNames)	{
    		objConfig.fieldNames  = config.fieldNames;
    	}
    	if(config.addFields)	{
    		if(Ext.isArray(config.addFields))	{
    			objConfig.addFields  = config.addFields;
    		} else {
    			objConfig.addFields  = [config.addFields]
    		}
    	}
    	if(config.chartSize)	{
    		objConfig.uniOpt.rendererOptions.c3 = {size : config.chartSize, locale : "ko"};
    	}
    	Ext.apply(this, objConfig);
        this.callParent([config]);
    },
    
    initComponent: function() {
    	var me = this;
    	
    	if(me.store)	{
    		me.store.on('beforeload', function()	{
    			me.mask("조회중..");
    		})
	    	me.store.on('load', function(store, records, successful, eOpts) {
	    		me.unmask();
	    		if(successful)	{
	    			me.onLoadRender();
	    		}
	    	})
    	}
    	if(me.initFields) {
        	me.fieldStore = me.setPivotFieldsStoreWithModel();
        }else if(me.grid){
    		me.fieldStore = me.setPivotFieldsStore();
        } else if( config.model ||config.store) {
        	me.fieldStore = me.setPivotFieldsStoreWithModel();
        }
    	
    	
    	var loadData = new Array();
    	var fields = {};
    	var strFieldsArr = [];
    	var strFieldNamesArr = [];
    	var i=0;
    	if(!me.fieldNames)	{
    		if(me.grid)	{
		    	Ext.each(me.fieldStore.getData().items, function(field){
		    		var defaultValue = null ;
		    		var t = field.get("type");
		    		var column = me.grid.getColumn(field.get("name"));
		    		
		    		if( column &&  t != 'uniPassword' && !column.hidden ) {
			    		if( t ==  'string') {
			    			defaultValue = '';
						} else if( UniUtils.indexOf(t, ['number','int','integer','float','uniNumber', 'uniQty','uniPrice','uniUnitPrice','uniPercent', 'uniFC','uniER'])) {
							defaultValue = 0;
						} else if( t ==  'bool' || t == 'boolean') {
							defaultValue = null;
						} else if( t ==  'date' || t ==  'uniDate') {
							defaultValue = '';
						} else if(t ==  'uniTime') {
							defaultValue = '00:00:00';
						} else if(t ==  'uniYear') {
							defaultValue = '';
						} 
			    		fields[field.get("text")] = defaultValue;
			    		strFieldsArr[i] = field.get("name");
			    		strFieldNamesArr[i] = field.get("text");
			    		i++;
					}
		    	})
	    	} else if(me.store ){
	    		Ext.each(me.fieldStore.getData().items, function(field){
		    		var defaultValue = null ;
		    		var t = field.get("type");
		    		
		    		if(  t != 'uniPassword'  ) {
			    		if( t ==  'string') {
			    			defaultValue = '';
						} else if( UniUtils.indexOf(t, ['number','int','integer','float','uniNumber', 'uniQty','uniPrice','uniUnitPrice','uniPercent', 'uniFC','uniER'])) {
							defaultValue = 0;
						} else if( t ==  'bool' || t == 'boolean') {
							defaultValue = null;
						} else if( t ==  'date' || t ==  'uniDate') {
							defaultValue = '';
						} else if(t ==  'uniTime') {
							defaultValue = '00:00:00';
						} else if(t ==  'uniYear') {
							defaultValue = '';
						} 
			    		fields[field.get("text")] = defaultValue;
			    		strFieldsArr[i] = field.get("name");
			    		strFieldNamesArr[i] = field.get("text");
			    		i++;
					}
		    	})
	    	}
    		me.fields = strFieldsArr;
        	me.fieldNames = strFieldNamesArr;
    	} else {
    		Ext.each(me.fieldNames, function(f) {
    			fields[f] = '';
    		})
    	}
    	
    	loadData.push(fields);
    	
    	$("#"+me.getId()).pivotUI(loadData, {aggregatorName : me.aggregatorName}, false, "ko");
    	//(input, inputOpts, overwrite, locale)
    	
		this.on('render', this.onLoadRender, this);        
		
        this.callParent(arguments);
       
    },
    addField : function(data)	{
    	var me = this;
    	
    	Ext.isFunction
    },
    onLoadRender : function()	{
    	var me = this
    	var data = me.store.getData().items;
    	var loadDataList = new Array();
    	
    	if(!Ext.isEmpty(data))	{
    		Ext.each(data, function(record, i){
    			var loadData = {};
    			Ext.each(me.fields, function(name, j){
    				var fieldDataIdx = me.fieldStore.find("name", name);
    				if(fieldDataIdx > -1)	{
	    				var fieldData    = me.fieldStore.getAt(fieldDataIdx);
	    				if(fieldData.get("isCombo")){
	    					var comboStore = fieldData.get("comboStore");
	    					
	    					var comboValueIdx = -1;
	    					if(comboStore) comboValueIdx = comboStore.find("value",  record.get(name));
	    					if(comboValueIdx > -1)	{
	    						var comboValue = comboStore.getAt(comboValueIdx);
	    						loadData[me.fieldNames[j]] = comboValue.get("text");
	    					}else {
	    						loadData[me.fieldNames[j]] = record.get(name);
	    					}
	    				} else if(fieldData.get("type")=="uniDate") {
	    					loadData[me.fieldNames[j]] = UniDate.extFormatDate(record.get(name));
	    				} else {
	    					loadData[me.fieldNames[j]] = record.get(name);
	    				}
    				} else {
    					loadData[me.fieldNames[j]] = record.get(name);
    				}
    			});
    			if(me.addFields) {
    	    		Ext.each(me.addFields, function(func){
    	    			loadData[func.text] = func.addfunction.call(me, record);
    	    		})
    	    	}
    			
    			loadDataList.push(loadData);
    		});
    		if(Ext.isEmpty(me.uniOpt.renderers))	{	
    			if(!Ext.isDefined(me.uniOpt.userLang) || (Ext.isDefined(me.uniOpt.userLang) && me.uniOpt.userLang.tolowercase == "ko" ) )	{
    				
    				me.uniOpt.renderers = {
				    	"표"			: $.pivotUtilities.renderers["Table"],
					    "히트맵(열지도)"	: $.pivotUtilities.renderers["Heatmap"],
					    "가로 막대형" 	: $.pivotUtilities.c3_renderers["Horizontal Bar Chart"],
		    	        "가로 누적막대형"	: $.pivotUtilities.c3_renderers["Horizontal Stacked Bar Chart"],
		    	        "세로 막대형" 	: $.pivotUtilities.c3_renderers["Bar Chart"],
		    	        "세로 누적막대형"	: $.pivotUtilities.c3_renderers["Stacked Bar Chart"],
		    	        "꺽은선형" 	: $.pivotUtilities.c3_renderers["Line Chart"],
		    	        "면적그래프" 	: $.pivotUtilities.c3_renderers["Area Chart"],
		    	        "산점도" 		: $.pivotUtilities.c3_renderers["Scatter Chart"],
		    	        "내보내기" 	: $.pivotUtilities.export_renderers["TSV Export"]
				    }
    				/*
    				me.uniOpt.renderers = {
    						[UniUtils.getLabel('system.label.commonJS.pivotTable'					,"표"			)] : $.pivotUtilities.renderers["Table"],                    
    				        [UniUtils.getLabel('system.label.commonJS.pivotHeatmap'					,"히트맵(열지도)"	)] : $.pivotUtilities.renderers["Heatmap"],                           
    				        [UniUtils.getLabel('system.label.commonJS.pivotHorizontalBarChart'		,"가로 막대형"		)] : $.pivotUtilities.c3_renderers["Horizontal Bar Chart"],           
    				        [UniUtils.getLabel('system.label.commonJS.pivotHorizontalStackedBarChart',"가로 누적막대"	)] : $.pivotUtilities.c3_renderers["Horizontal Stacked Bar Chart"],   
    				        [UniUtils.getLabel('system.label.commonJS.pivotBarChart'				,"세로 막대형"		)] : $.pivotUtilities.c3_renderers["Bar Chart"],                      
    				        [UniUtils.getLabel('system.label.commonJS.pivotStackedBarChart'			,"세로 누적막대"		)] : $.pivotUtilities.c3_renderers["Stacked Bar Chart"],              
    				        [UniUtils.getLabel('system.label.commonJS.pivotLineChart'				,"꺽은선형" 		)] : $.pivotUtilities.c3_renderers["Line Chart"],                         
    				        [UniUtils.getLabel('system.label.commonJS.pivotAreaChart'				,"면적그래프" 		)] : $.pivotUtilities.c3_renderers["Area Chart"],                     
    				        [UniUtils.getLabel('system.label.commonJS.pivotScatterChart'			,"산점도" 			)] : $.pivotUtilities.c3_renderers["Scatter Chart"],                  
    				        [UniUtils.getLabel('system.label.commonJS.pivotTSVExport'				,"내보내기" 		)] : $.pivotUtilities.export_renderers["TSV Export"]                      
    				};           
    				*/
    			}
					    
    		}
    		
    		
    		$("#"+me.getId()).pivotUI(loadDataList, me.uniOpt, true, "ko");
    	}
    	
    },
    setPivotFieldsStore : function()	{
		var me = this;
		var fieldStore ;
		
		if(me.store.model)	{
        	
        	var fields = me.store.model.getFields();
        	var columnData = new Array();
        	Ext.each(fields, function(field, idx){
        		var column =  me.grid.getColumn(field.name);
        		if (column != null && column.xtype != 'actioncolumn' && column.xtype != 'rownumberer'&& column.xtype != 'checkcolumn' && (column.dataIndex != ''&& column.dataIndex != null) && (column.dataIndex != '*') ) {
        			var isCombo = false;
        			var includeMainCode = false;
        			var comboStore = {};
        			if(!Ext.isEmpty(field.store))	{
        				isCombo = true;
        				comboStore = field.store;
        			}
        			if(!Ext.isEmpty(field.comboType))	{
        				isCombo = true;
        				includeMainCode = false;
        				comboStore = Ext.data.StoreManager.lookup("CBS_"+field.comboType+"_"+Unilite.nvl(field.comboCode,''));
        				if(!Ext.isEmpty(field.includeMainCode))	{
        					includeMainCode =  true;
        					comboStore = Ext.data.StoreManager.lookup("CBS_MAIN_"+field.comboType+"_"+Unilite.nvl(field.comboCode,''));
        				}
        			}
        			columnData.push({
        					'name' : column.dataIndex,
        					'text' : column.text.replace("<span style='color:#f00 !important;font-weight:bold'>*</span>",""),
        					'type' : field.type,
        					'hidden' : column.hidden,
        					'isCombo' : isCombo,
        					'includeMainCode' : includeMainCode,
        					'comboStore' : comboStore
        			});
        		}
        	});
        	me.addConfigFields(columnData);
        	if(Ext.isEmpty(Ext.data.StoreManager.lookup(me.grid.getId()+'PIVOTFieldStore'))){
        		fieldStore = Ext.create('Ext.data.Store',{
	        		id : me.grid.getId()+'PIVOTFieldStore',
	        		fields: [
	        			 {name: 'name' 		,type:'string'	},
		   				 {name: 'text' 	    ,type:'string'	},
		   				 {name: 'type' 	    ,type:'string'	},
		   				 {name: 'hidden' 	,type:'string'	},
		   				 {name: 'isCombo' 	,type:'bool'	},
		   				 {name: 'includeMainCode' 	,type:'bool'	},
		   				 {name: 'comboStore' 	}
		   			],
	        		data  : columnData
	        	})
        	} else {
        		fieldStore = Ext.data.StoreManager.lookup(me.grid.getId()+'PIVOTFieldStore');
				fieldStore.loadData(columnData);
        	}
        }
    	return fieldStore;
	},
	setPivotFieldsStoreWithModel : function()	{
		var me = this;
		var fieldStore ;
		
		if(me.model || me.initFields || me.store)	{
			var fields ;
			if(me.initFields )	{
				fields = me.initFields;
			} else if(me.model) {
				fields = me.model.getFields();
			} else {
				fields = me.store.model.getFields();
			}
        	var columnData = new Array();
        	var fieldTexts = new Array();
        	var fieldNames = new Array();
        	Ext.each(fields, function(field, idx){
        		if(!Unilite.nvl(field.hidden, false) && !Ext.isEmpty(field.text))	{
        			fieldNames.push(field.name);
        			fieldTexts.push(field.text);
        			var isCombo = false;
        			var comboStore = {};
        			var includeMainCode = false; 
        			if(!Ext.isEmpty(field.store))	{
        				isCombo = true;
        				comboStore = field.store;
        			}
        			if(!Ext.isEmpty(field.comboType))	{
        				isCombo = true;
        				includeMainCode = false;
        				comboStore = Ext.data.StoreManager.lookup("CBS_"+field.comboType+"_"+Unilite.nvl(field.comboCode,''));
        				if(!Ext.isEmpty(field.includeMainCode))	{
        					includeMainCode =  true;
        					comboStore = Ext.data.StoreManager.lookup("CBS_MAIN_"+field.comboType+"_"+Unilite.nvl(field.comboCode,''));
        				}
        			}
	    			columnData.push({
	    					'name' : field.name,
	    					'text' : field.text,
	    					'type' : Unilite.nvl(field.type, 'string'),
	    					'hidden' : false,
	    					'isCombo' : isCombo,
	    					'includeMainCode' : field.includeMainCode,
	    					'comboStore' : comboStore
	    			});
        		}
        	});
        	me.fieldNames = fieldTexts;
        	me.fields = fieldNames;
        	if(me.addFields)	{
        		me.addConfigFields(columnData);
        	}
        	if(Ext.isEmpty(Ext.data.StoreManager.lookup(me.id+'PIVOTFieldStore'))){
        		fieldStore = Ext.create('Ext.data.Store',{
	        		id : me.id+'PIVOTFieldStore',
	        		fields: [
	        			 {name: 'name' 		,type:'string'	},
		   				 {name: 'text' 	    ,type:'string'	},
		   				 {name: 'type' 	    ,type:'string'	},
		   				 {name: 'hidden' 	,type:'string'	},
		   				 {name: 'isCombo' 	,type:'bool'	},
		   				 {name: 'includeMainCode' 	,type:'bool'	},
		   				 {name: 'comboStore' 	}
		   			],
	        		data  : columnData
	        	})
        	} else {
        		fieldStore = Ext.data.StoreManager.lookup(me.id+'PIVOTFieldStore');
				fieldStore.loadData(columnData);
        	}
        } 
    	return fieldStore;
	},
	addConfigFields : function (columnData )	{
		var me = this;
		if(me.addFields) {
    		Ext.each(me.addFields, function(func){
    			//loadData[func.text] = func.addfunction.call(me, record);
    			columnData.push({
						'name' : func.name.replace("<span style='color:#f00 !important;font-weight:bold'>*</span>",""),
						'text' : func.text,
						'type' : Unilite.nvl(func.type, 'string'),
						'hidden' : false,
						'isCombo' : false,
						'includeMainCode' : false,
						'comboStore' : null
				});
    		})
    	}
	}
    
});   