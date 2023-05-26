
/**
 * 2019.09.04  Grid column 에 excelWidth 속성 추가 : 엑셀다운로드시 excelWidth 값이 있으면 너비를 excelWidth 값으로 한다. excelWidth 설정이 없다면 width를 사용한다.
 */ 
Ext.define('MyApp.view.override.Grid', {
	override: 'Ext.grid.GridPanel',
	/*
		Kick off process
	*/
	downloadExcelXml: function(includeHidden, title) {
		/*if(UniAppManager && UniAppManager.app && Ext.isFunction(UniAppManager.app._needSave) && UniAppManager.app._needSave()) {
			UniUtils.getLabel('system.message.commonJS.grid.excel.saveAlert','저장할 데아타가 있습니다. 저장 후 엑셀다운로드 하세요.'); //alert('저장할 데아타가 있습니다. 저장 후 엑셀다운로드 하세요.');
			return;
		}*/
		var store = this.getStore();

		if(store && store.getData().items.length > Unilite.nvl(EXCEL_MAX_ROWS, 1000)) {
			if(!confirm(UniUtils.getLabel('system.message.commonJS.grid.excel.maxRowAlert','다운로드 지정된 데이타량이 초과되었습니다. csv 파일로 다운로드 하시겠습니까?'))) {
				return;
			}
		}
		
		var me = this;
		if (!title) title = this.title;
 
		if (Ext.isEmpty(title)) {
			title = this.id ? this.id : 'Export';
		}/*else {
			if(title.indexOf("/") >= 0) {
				title = title.replace(/\//g, "");
			}
		}*/
		
		title = title.replace(/[`~!@#$%^&*()_|+\-=?;:'",.<>\{\}\[\]\\\/]/gi, "");
		
		var vExportContent = "", vConfigId ="";
		if(me.uniOpt.excel.configId) {
			vConfigId = me.uniOpt.excel.configId;
		} else {
			vExportContent = this.getExcelXml(includeHidden, title);
		}
		var vExportData = null;
		
		if(me.uniOpt.excel.exportGridData){
			vExportData = JSON.stringify(this.getJsonData(includeHidden));
		}
		var fileName = title + "-" + Ext.Date.format(new Date(), 'Y-m-d Hi');
			
		var serviceName = me.getStore().getProxy().getApi().read.$name;
		if(me.uniOpt.excel.serviceName && me.uniOpt.excel.serviceName != '') {
			serviceName = me.uniOpt.excel.serviceName
		}
		if(!Ext.isDefined(serviceName)) {
			Unilite.messageBox(UniUtils.getLabel('system.message.commonJS.grid.excel.readAlert','조회된 데이타가 없습니다.')); //alert("조회된 데이타가 없습니다.");
			//
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
				name: 'configId',
				value: vConfigId
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
			},{
				xtype: 'hiddenfield',
				name: 'isExportData',
				value: this.uniOpt.excel.exportGridData
			},{
				xtype: 'hiddenfield',
				name: 'exportData',
				value: vExportData
			}
			]
 			
		});
		
		if(arrServiceName.length == 2 ) {
			var name = null;
			if( top && top.exceldownload && top.exceldownload.children && top.exceldownload.children[0]) {
				name = top.exceldownload.children[0].name;
			}
			if(name) {
				form.getForm().submit(
					{
						params: {data:this.getParams(me.getStore().readParams)},
						target: name
					}
				);
			} else {
				form.getForm().submit(
					{
						params: {data:this.getParams(me.getStore().readParams)},
						target: '_new'
					}
				);
			}
		} else {
			Unilite.messageBox(UniUtils.getMessage('system.message.commonJS.grid.excel.proxyAlert','엑셀 다운로드 서비스가 없습니다.')); //alert("엑셀 다운로드 서비스가 없습니다.");
		}
	
	},
	getParams:function(params) {
		
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
 
   
	
	setCellType:function(format) {
		if(format.indexOf('.') > -1) {
			return 'number';
		} else {
			return 'integer';
		}
	},
	createWorksheet: function(includeHidden, theTitle) {
		var me = this;
		var cm = this.getView().getGridColumns();
		
		var store = this.getStore();
		var colCount = cm.length;
				var isSummary = false;
		var isGroupSummary = false;
		
		var gridFeatures ;
		if(this.getView().normalGrid && this.getView().normalGrid.features ) {
			gridFeatures = this.getView().normalGrid.features;
		} else if(this.getView().features && Ext.isDefined(this.getView().features)) {
			gridFeatures = this.getView().features;
		}
		
		if(me.uniOpt.excel.summaryExport) {
			if(gridFeatures) 	{
				Ext.each(gridFeatures, function(item, idx){
					if(item.ftype.indexOf('uniSummary') > -1) {
						if(Ext.isDefined(item.showSummaryRow) && item.showSummaryRow === true) {
							isSummary = true;
						}	
					} else if(item.ftype.indexOf('uniGroupingsummary') > -1 && me.uniOpt.excel.exportGroup) {
						if(Ext.isDefined(item.showSummaryRow) && item.showSummaryRow === true) {
							isGroupSummary = true;
						}	
					}
				})
			}
		}
		
		var colXml = '<sheet name="'+theTitle+'" desc="'+theTitle+'" startRow="2" ' ;
		
		if(store) {
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
		var isCheckBoxModel = false;
		/*
		if(this.getView().normalGrid && this.getView().normalGrid.features) {
			if( this.getView().normalGrid.features.length == 2 
				&& ( (Ext.isDefined(this.getView().normalGrid.features[0].ftype) && this.getView().normalGrid.features[0].ftype == "uniSummary") || 
					 (Ext.isDefined(this.getView().normalGrid.features[1].ftype) && this.getView().normalGrid.features[1].ftype == "uniSummary") )	
			) {
				isSummary = true;
			}
			if( this.getView().normalGrid.features.length == 1 
				&& Ext.isDefined(this.getView().normalGrid.features[0].ftype) && this.getView().normalGrid.features[0].ftype == "uniSummary" ) {
				isSummary = true;
			}
		} else if(this.getView().features && Ext.isDefined(this.getView().features)) {
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
		var headerXml = "";
		if(me.config.columns) {
			//var headerItems = me.config.columns;
			var headerItems;
			if(me.lockedGrid) {
				var headerItems1  =  me.lockedGrid.getHeaderContainer().items.items;
				var headerItems2 =  me.normalGrid.getHeaderContainer().items.items;
				headerItems = headerItems1.concat(headerItems2);
			} else {
				headerItems =  me.getHeaderContainer().items.items;
			}
			var columDepth = 0; 
			me.maxHeaderRow=1;
			Ext.each(headerItems, function(column, hIdx){
				//console.log(column.text, " columDepth : ",columDepth, " maxRow : ",me.maxHeaderRow);
					me.getHeaderRowConfig(column, columDepth);
			});
			var hCol = 0;
			Ext.each(headerItems, function(item, hIdx){
				if((item.items.items && item.items.items.length > 0 &&  !me.isChildrenHidden(item.items.items)) || (item.xtype != 'actioncolumn' && item.xtype != 'rownumberer'&& item.xtype != 'checkcolumn' && (item.dataIndex != ''&& item.dataIndex != null) && (item.dataIndex != '*') && !item.hidden)) {
					var iText = !Ext.isEmpty(item.text) ? item.text:"";
					iText = iText.replace("<span style='color:#f00 !important;font-weight:bold'>*</span>","");
					iText = iText.replace(/<(.|\n)*?>/, "");
					
					headerXml +='<header col="'+hCol+'" text="'+iText+'" maxRows="'+me.maxHeaderRow+'" ';
					if(item.excelWidth) {
						headerXml +=' width="'+item.excelWidth+'"';
					} else if(item.width) {
						headerXml +=' width="'+item.width+'"';
					}
					hCol++;
					if(item.items.items && item.items.items.length > 0) {
						var colspan = 0;
						/*
						 Ext.each(item.columns, function(childItem, idx2) {
							if(childItem.hasChild || (childItem.xtype != 'actioncolumn' && childItem.xtype != 'rownumberer'&& childItem.xtype != 'checkcolumn' && (childItem.dataIndex != ''&& childItem.dataIndex != null) && (childItem.dataIndex != '*') && !childItem.hidden)) {
								colspan++;
							}
						});
						*/
						colspan = me.getColspan(item);
						if(colspan == 0) { item.colspan=1};
						headerXml +=' colspan="'+item.colspan+'" >';
						
						headerXml += me.getChildHeaerXml(item);
						headerXml +='</header>';
					} else 	{
						if(!item.columnDepth ) {
							item.columnDepth = 0;
						}
						headerXml +=' rowspan="'+(me.maxHeaderRow - item.columnDepth)+'"  />';
					}
				}
			});
			colXml = colXml + headerXml;
		}
		
		var skipcol = 0;
		for (var i = 0; i < colCount; i++) {
			
			if(cm[i].xtype == 'rownumberer'){
				isRowNumber = true;
				//skipcol++;
			}
			if(cm[i].xtype == 'checkcolumn'){
				isCheckBoxModel = true;
				//skipcol++;
			}
			
			if (cm[i].xtype != 'actioncolumn' && cm[i].xtype != 'rownumberer'&& cm[i].xtype != 'checkcolumn' && (cm[i].dataIndex != ''&& cm[i].dataIndex != null) && (cm[i].dataIndex != '*') && (includeHidden || !cm[i].hidden)) {
			 	var fld = this.getModelField(cm[i].dataIndex);   
				if(isRowNumber || isCheckBoxModel)  {
					//skipcol++;
					isRowNumber = false;
					isCheckBoxModel = false;
				}
				col = i - skipcol;
				
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
								vFormat = UniFormat.Price;
								break;
							case "float":
								if(fld.format) {
									type = this.setCellType(fld.format);
									vFormat = fld.format;
								} else {
									type = 'integer';
								}
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
								vFormat = Unilite.dateFormat;
								break;
							case "date":
								type = 'string';
								break;
							default:
								type = 'string';
								break;
						}
					} 
					var colTitle = cm[i].text.replace("<span style='color:#f00 !important;font-weight:bold'>*</span>","") 
					colTitle = colTitle.replace(/<(.|\n)*?>/, "");
					if(cm[i].isSubHeader) {
						colTitle = this.getColumnText(cm[i], colTitle);
					}
					colXml += '<field col="'+col+'"' +
									 ' title="'+colTitle+'" ' +
									 ' name="'+cm[i].dataIndex+'"'+
									 ' width="' + (cm[i].excelWidth ? cm[i].excelWidth:cm[i].width) + '"' +
									 ' align="' +cm[i].align +'"'+
									 ' type="' +type +'"'+
									 ' format="' +vFormat +'"';
					
					if(fld) {
						if(fld.comboType) {
							colXml += ' comboType="' +fld.comboType +'"';
						}
						if(fld.comboCode) {
							colXml += ' comboCode="' +fld.comboCode +'"';
						}
						if(fld.includeMainCode) {
							colXml += ' includeMainCode="' +fld.includeMainCode +'"';
						}
						if(store.model.getField(cm[i].dataIndex).store && (!Ext.isDefined(fld.comboCode) || fld.comboType != 'AU' )) {
							var comboDataArr = "{" ;
							Ext.each(store.model.getField(cm[i].dataIndex).store.data.items, function(item, idx){
								comboDataArr = comboDataArr +"'"+item.data.value+"':'"+ item.data.text.replace(/&/g, '')+"',";
							});
							if(comboDataArr == "{") {
								comboDataArr = "{}";
							} else {
								comboDataArr = comboDataArr.substring(0, comboDataArr.length-1)+"}";
							}
							colXml += ' comboData="' +comboDataArr +'"';
						}
						if(fld.includeMainCode) {
							var comboDataArr = "{" ;
							Ext.each(cm[i].editor.getStore().data.items, function(item, idx){
								comboDataArr = comboDataArr +"'"+item.data.value+"':'"+ item.data.text.replace(/&/g, '')+"',";
							});
							if(comboDataArr == "{") {
								comboDataArr = "{}";
							} else {
								comboDataArr = comboDataArr.substring(0, comboDataArr.length-1)+"}";
							}
							colXml += ' comboData="' +comboDataArr +'"';
						}
						
					}

					if(isSummary || isGroupSummary) {
						if(cm[i].summaryType && !Ext.isFunction(cm[i].summaryType)) {
							colXml += ' summaryType="' + cm[i].summaryType +'"';
						}
						if(Ext.isFunction(cm[i].summaryRenderer)) {
							colXml += ' summaryfunction="' +theTitle+cm[i].dataIndex+'"';
						}
					}
					colXml +=  '/>';
				}
			} else {
				skipcol++;
			}
		}
		colXml +='</sheet>';
		result={xml :colXml};
		return result;
	},
	getChildHeaerXml:function(headerItems){
		var headerNode = "";
		var me = this;
		var hCol=0;

		Ext.each(headerItems.items.items, function(item, hIdx){
		//Ext.each(headerItems.columns, function(item, hIdx){
			if((item.items.items &&  item.items.items.length > 0 && !me.isChildrenHidden(item.items.items) ) || (item.xtype != 'actioncolumn' && item.xtype != 'rownumberer'&& item.xtype != 'checkcolumn' && (item.dataIndex != ''&& item.dataIndex != null) && (item.dataIndex != '*') && !item.hidden )) {
				var iText = !Ext.isEmpty(item.text) ? item.text:"";
				iText = iText.replace("<span style='color:#f00 !important;font-weight:bold'>*</span>","");
				iText = iText.replace(/<(.|\n)*?>/, "");
				headerNode +='<header col="'+hCol+'" text="'+iText+'" ';
				
				if(item.excelWidth) {
					headerNode +=' width="'+item.excelWidth+'"';
				} else if(item.width) {
					headerNode +=' width="'+item.width+'"';
				}
				hCol++;
				if(item.items.items && item.items.items.length > 0) {
					if(!item.colspan) {
						item.colspan = 1;
					}
					headerNode +=' colspan="'+item.colspan+'" >';
					headerNode += me.getChildHeaerXml(item);
					headerNode +='</header>';
				} else {
					headerNode +=' rowspan="'+(me.maxHeaderRow - item.columDepth)+'" ';
					headerNode +='/>';
				}
			}
		});
		return headerNode;
	}, 
	isChildrenHidden : function (items) {
		var r = false;
		var hiddenCnt =0;
		Ext.each(items, function(item){
			if(item.hidden) {
				hiddenCnt++;
			}
		});
		if(hiddenCnt == items.length) {
			r = true;
		}
		return r;
	},
	getHeaderRowConfig:function(column, columDepth){
		var me = this;
		column.columDepth = columDepth;
		if(column.items && column.items.items && column.items.items.length > 0 ) {
			columDepth++;
			column.hasChild = true;
			if(columDepth >= me.maxHeaderRow) {
				me.maxHeaderRow++;
			}
			Ext.each(column.items.items, function(cColumn,idx){
				me.getHeaderRowConfig(cColumn, columDepth);
			});
		}
	},
	getColspan:function(column) {
		var nCol = 0;
		var grandChildCols = 0;
		var me = this;
		if(column.items && column.items.items && column.items.items.length > 0) {
			/*Ext.each(column.columns, function(childColumn, idx){
				if(childColumn.hasChild || (childColumn.xtype != 'actioncolumn' && childColumn.xtype != 'rownumberer'&& childColumn.xtype != 'checkcolumn' && (childColumn.dataIndex != ''&& childColumn.dataIndex != null) && (childColumn.dataIndex != '*') && !childColumn.hidden)) {
						nCol++;
				}
			})*/
			Ext.each(column.items.items, function(childColumn, idx){
				if((childColumn.items.items && childColumn.items.items.length > 0)|| (childColumn.xtype != 'actioncolumn' && childColumn.xtype != 'rownumberer'&& childColumn.xtype != 'checkcolumn' && (childColumn.dataIndex != ''&& childColumn.dataIndex != null) && (childColumn.dataIndex != '*') && !childColumn.hidden)) {
					if(childColumn.items.items && childColumn.items.items.length > 0) {
						grandChildCols = grandChildCols + me.getColspan(childColumn);
					} else {
						nCol++; 
					}
				}
			})
			nCol = nCol+grandChildCols;
			
		}
		column.colspan = nCol;
		return nCol;
	
	},
	getJsonData: function(includeHidden) {
		var cm = this.getView().getGridColumns();
		var jsonData = new Array();

		// Generate worksheet header details.
		// determine number of rows
		var numGridRows = this.store.getCount() 
		if (!Ext.isEmpty(this.store.groupField)) {
			numGridRows = numGridRows + this.store.getGroups().length;
		}

		// create header for worksheet
		// Generate the data rows from the data in the Store
		var groupVal = "";
		for (var i = 0, it = this.store.data.items, l = it.length; i < l; i++) {
			if (this.uniOpt.exportGroup && !Ext.isEmpty(this.store.groupField)) {
				if (groupVal != this.store.getAt(i).get(this.store.groupField)) {
					groupVal = this.store.getAt(i).get(this.store.groupField);
					var key = this.store.groupField;
					jsonData.push({key : groupVal});
				}
			}
			//var cellClass = (i & 1) ? 'odd' : 'even';
			r = it[i].data;
			var rowData = {}
			var k = 0;
			var colCount = cm.length;
			for (var j = 0; j < colCount; j++) {
				if (cm[j].xtype != 'actioncolumn' && cm[j].xtype != 'rownumberer' &&  (cm[j].dataIndex != '') && (includeHidden || !cm[j].hidden)) {
					var v = cm[j].dataIndex ? r[cm[j].dataIndex] : '';
					if(Ext.isFunction(cm[j].renderer)) {
						if(this.getView().getCell(it[i], j) && this.getView().getCell(it[i], j).dom && this.getView().getCell(it[i], j).dom.innerText) {
							v = this.getView().getCell(it[i], j).dom.innerText.replace(/,/gi,'');
						} else {
							console.log("dom error : ", cm[j].dataIndex, cm[j])
						}
					}
					rowData[cm[j].dataIndex] = v;
					k++;
				}
			}
			jsonData.push(rowData);
		}
		return jsonData;
	},
	getColumnText: function(col, colTitle) {
		colTitle = col.ownerCt.text + ' '+colTitle;
		if(col.ownerCt.isSubHeader) {
			colTitle = this.getColumnText(col.ownerCt, colTitle );
		}
		return colTitle;
	}
});