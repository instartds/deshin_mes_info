 //@charset UTF-8 
//    http://druckit.wordpress.com/2013/10/26/generate-an-excel-file-from-an-ext-js-4-grid/
// https://fiddle.sencha.com/#fiddle/17j

Ext.define('MyApp.view.override.Grid', {
    override: 'Ext.grid.GridPanel',
 
 
    /*
        Kick off process
    */
    downloadExcelXml: function(includeHidden, title) {
    	
    	if(UniAppManager && UniAppManager.app && Ext.isFunction(UniAppManager.app._needSave) && UniAppManager.app._needSave())	{
    		alert('저장할 데아타가 있습니다. 저장 후 엑셀다운로드 하세요.');
    		return;
    	}
    	
  		var me = this;
        if (!title) title = this.title;
 
        if (Ext.isEmpty(title)) {
        	title = this.id ? this.id : 'Export';
        }else {
        	if(title.indexOf("/") >= 0)	{
        		title = title.replace(/\//g, "");
        	}
        }
        
        var vExportContent = this.getExcelXml(includeHidden, title);
 		
        var fileName = title + "-" + Ext.Date.format(new Date(), 'Y-m-d Hi');
        	
    	var serviceName = me.getStore().getProxy().getApi().read.$name;
    	if(!Ext.isDefined(serviceName))	{
    		alert("조회된 데이타가 없습니다.");
    		return;
    	}
        var arrServiceName = serviceName.split(".");
        
        var form = this.down('form#uploadForm');
        if (form) {
            form.destroy();
        }
        form = this.add({
            xtype: 'form',
            itemId: 'uploadForm',
            hidden: true,
            standardSubmit: true,
            url: CPATH+'/download/downloadExcel.do',
            items: [{
                xtype: 'hiddenfield',
                name: 'xmlData',
                value: vExportContent
            },{
                xtype: 'hiddenfield',
                name: 'pgmId',
                value: PGM_ID
            },{
            	xtype: 'hiddenfield',
            	name: 'extAction',
            	value : arrServiceName[0]
            },{
            	xtype: 'hiddenfield',
            	name: 'extMethod',
            	value : arrServiceName[1]
            },{
            	xtype: 'hiddenfield',
            	name: 'fileName',
            	value : fileName
            },{
            	xtype: 'hiddenfield',
            	name: 'onlyData',
            	value : this.uniOpt.excel.onlyData
            }
            ]
 			
        });
        
        if(arrServiceName.length == 2 )	{
        
            form.getForm().submit(
            	{
            		params: {data:this.getParams(me.getStore().readParams)}
            	}
            );
        }else {
        	alert("엑셀 다운로드 서비스가 없습니다.");
        }
    
    },
	getParams:function(params)	{
		
		return Ext.JSON.encode(params);
	},
    getExcelXml: function(includeHidden, title) {

        var theTitle = title || this.title;
        
        var worksheet = this.createWorksheet(includeHidden, theTitle);        
        var totalWidth = this.columns.length;
		//<?xml version="1.0" encoding="utf-8" ?>
        return ''.concat(
            '<?xml version="1.0" encoding="UTF-8"  ?>',
			'<!DOCTYPE excelDownload PUBLIC ',
        	' "-//TLab//DTD excep upload config XML V1.0//EN" ',
         	'"../ExcelDownload/dtd/excel-download.dtd">',
            '<workBook name="'+PGM_ID+'" desc="'+theTitle+'" >',
             worksheet.xml,
        	'</workBook>'
        );
    },
 

 
    getModelField: function(fieldName) {
 
        var fields = this.store.model.getFields();
        for (var i = 0; i < fields.length; i++) {
            if (fields[i].name === fieldName) {
                return fields[i];
            }
        }
    },
 
   
    
    setCellType:function(format)	{
    	if(format.indexOf('.') > -1)	{
    		return 'number';
    	}else {
    		return 'integer';
    	}
    },
    createWorksheet: function(includeHidden, theTitle) {
      
        var cm = this.getView().getGridColumns();
        
        var store = this.getStore();
        var colCount = cm.length;
                var isSummary = false;
        var isGroupSummary = false;
        
        var gridFeatures ;
        if(this.getView().normalGrid && this.getView().normalGrid.features )	{
        	gridFeatures = this.getView().normalGrid.features;
        }else if(this.getView().features && Ext.isDefined(this.getView().features))	{
        	gridFeatures = this.getView().features;
        }
        
        if(gridFeatures) 	{
        	Ext.each(gridFeatures, function(item, idx){
        		if(item.ftype.indexOf('uniSummary') > -1)	{
        			if(Ext.isDefined(item.showSummaryRow) && item.showSummaryRow === true)	{
        				isSummary = true;
        			}	
        		}else if(item.ftype.indexOf('uniGroupingsummary') > -1)	{
        			if(Ext.isDefined(item.showSummaryRow) && item.showSummaryRow === true)	{
        				isGroupSummary = true;
        			}	
        		}
        	})
        }
        
        var colXml = '<sheet name="'+theTitle+'" desc="'+theTitle+'" startRow="2" ' ;
        
        if(store)	{
	        if(Ext.isDefined(store.getProxy()) ) {
	        	colXml += 'readService="'+store.getProxy().getApi().read.$name+'"' ;
	        }
        	if(Ext.isDefined(store.getGroupField()) ) {
        		colXml +=  ' groupField="'+store.getGroupField()+'" ' ;
        	}
        	
        	
        	
        }
        colXml +=  ' isSummary="'+isSummary+'" ' 
        colXml +=  ' isGroupSummary="'+isGroupSummary+'" ' 
        colXml += '>';
        var col = 0;
        var isRowNumber = false;

        /*
        if(this.getView().normalGrid && this.getView().normalGrid.features) {
        	if( this.getView().normalGrid.features.length == 2 
        		&& ( (Ext.isDefined(this.getView().normalGrid.features[0].ftype) && this.getView().normalGrid.features[0].ftype == "uniSummary") || 
        		     (Ext.isDefined(this.getView().normalGrid.features[1].ftype) && this.getView().normalGrid.features[1].ftype == "uniSummary") )	
        	) {
        		isSummary = true;
        	}
        	if( this.getView().normalGrid.features.length == 1 
        		&& Ext.isDefined(this.getView().normalGrid.features[0].ftype) && this.getView().normalGrid.features[0].ftype == "uniSummary" )	{
        		isSummary = true;
        	}
        }else if(this.getView().features && Ext.isDefined(this.getView().features)) {
        	if( this.getView().features.length == 2 
        		&&  (  (Ext.isDefined(this.getView().features[0].ftype) && this.getView().features[0].ftype == "uniSummary") || 
        			   (Ext.isDefined(this.getView().features[1].ftype) && this.getView().features[1].ftype == "uniSummary"))	
        	) {
        		isSummary = true;
        	}
        	
        	if( this.getView().features.length == 1 &&  Ext.isDefined(this.getView().features[0].ftype) && this.getView().features[0].ftype == "uniSummary" )	
            {
        		isSummary = true;
        	}
        }
        */
        
        for (var i = 0; i < colCount; i++) {
        	
        	if(cm[i].xtype == 'rownumberer'){
        		isRowNumber = true;
        	}
            if (cm[i].xtype != 'actioncolumn' && cm[i].xtype != 'rownumberer' && (cm[i].dataIndex != '') && (cm[i].dataIndex != '*') && (includeHidden || !cm[i].hidden)) {
             	var fld = this.getModelField(cm[i].dataIndex);   
				if(isRowNumber)  {
					col = i-1;
				}else {
					col = i
				}
                if (cm[i].text !== "")  {
                	
                	var type = 'string';
                	var vFormat = '';
                	if(fld) {
	                    switch (fld.type) {
	                    	case "uniQty":
	                    		type = this.setCellType(UniFormat.Qty);
	                    		vFormat = UniFormat.Qty;
	                    		break;
	                    	case 'uniUnitPrice':
	                    		type = this.setCellType(UniFormat.UnitPrice);
	                    		vFormat = UniFormat.UnitPrice;
	                    		break;
	                        case "int":
	                            type = 'integer';
	                            break;
                            case "uniPrice":
                            	type = this.setCellType(UniFormat.Price);
	                    		vFormat = UniFormat.Qty;
                            	break;
	                        case "float":
	                            type = 'integer';
                            	break;
                            case "uniPercent":
                                type = this.setCellType(UniFormat.Percent);
	                    		vFormat = UniFormat.Percent;
                            	break;
                            case "uniFC":
                                type = this.setCellType(UniFormat.FC);
                                vFormat = UniFormat.FC;
                            	break;
                            case "uniER":
                                type = this.setCellType(UniFormat.ER);
                                vFormat = UniFormat.ER;
                            	break;
	                        case "bool":
								type = 'string';
                            	break;
	                        case "boolean":
	                            type = 'string';
                            	break;
                            case "uniDate":
                            	type = 'string';
                            	break;
	                        case "date":
	                            type = 'string';
                            	break;
	                        default:
	                            type = 'string';
                            	break;
	                    }
                    } 
                	
                    colXml += '<field col="'+col+'"' +
                    				 ' title="'+cm[i].text.replace("<span style='color:#f00 !important;font-weight:bold'>*</span>","")+'" ' +
                    				 ' name="'+cm[i].dataIndex+'"'+
                    				 ' width="' + cm[i].width + '"' +
                    				 ' align="' +cm[i].align +'"'+
                    				 ' type="' +type +'"'+
                    				 ' format="' +vFormat +'"';
                    
                    if(fld)	{
                    	if(fld.comboType) {
	                    	colXml += 		 ' comboType="' +fld.comboType +'"';
                    	}
                    	if(fld.comboCode) {
	                    	colXml += 		 ' comboCode="' +fld.comboCode +'"';
                    	}
                    	if(store.model.getField(cm[i].dataIndex).store && (!Ext.isDefined(fld.comboCode) || fld.comboType != 'AU' ))	{
                    		var comboDataArr = "{" ;
                    		Ext.each(store.model.getField(cm[i].dataIndex).store.data.items, function(item, idx){
                    			comboDataArr = comboDataArr +"'"+item.data.value+"':'"+ item.data.text.replace(/&/g, '')+"',";
                    		});
                    		var comboDataArr = comboDataArr.substring(0, comboDataArr.length-1)+"}";
                    		colXml += 		 ' comboData="' +comboDataArr +'"';
                    	}                   	
                    	
                	}
                	
                	
                	
                	if(isSummary || isGroupSummary) {		
                		if(cm[i].summaryType && !Ext.isFunction(cm[i].summaryType)) {
	                    	colXml += 		 ' summaryType="' + cm[i].summaryType +'"';
	                    }
	                    if(Ext.isFunction(cm[i].summaryRenderer)) {
	                    	colXml += 		 ' summaryfunction="' +theTitle+cm[i].dataIndex+'"';
	                    }
                	}
                    colXml +=  '/>';
                }
            }
        }
        colXml +='</sheet>';
        result={xml :colXml};
        return result;
    }
});