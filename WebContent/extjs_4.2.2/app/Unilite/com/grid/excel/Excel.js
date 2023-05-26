 //@charset UTF-8 
//    http://druckit.wordpress.com/2013/10/26/generate-an-excel-file-from-an-ext-js-4-grid/
// https://fiddle.sencha.com/#fiddle/17j

/*
 
    Excel.js - convert an Ext 4 grid into an Excel spreadsheet using nothing but
    javascript and good intentions.
 
    By: Steve Drucker
    October 26, 2013
    Original Ext 3 Implementation by: Nige "Animal" White?
    
    Updated: March 19, 2014 to support grouped grids/stores
    Updated: April 3, 2014 to support Internet Explorer
     
    Contact Info:
 
    e. sdrucker@figleaf.com
    blog: druckit.wordpress.com
    linkedin: www.linkedin.com/in/uberfig
    git: http://github.com/sdruckerfig
    company: Fig Leaf Software (http://www.figleaf.com / http://training.figleaf.com)
 
    Invocation:  grid.downloadExcelXml(includeHiddenColumns,title)
 
*/
 
 
var Base64 = (function() {
    // Private property
    var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
 
    // Private method for UTF-8 encoding
 
    function utf8Encode(string) {
        string = string.replace(/\r\n/g, "\n");
        var utftext = "";
        for (var n = 0; n < string.length; n++) {
            var c = string.charCodeAt(n);
            if (c < 128) {
                utftext += String.fromCharCode(c);
            } else if ((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            } else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }
        }
        return utftext;
    }
 
    // Public method for encoding
    return {
        encode: (typeof btoa == 'function') ? function(input) {
            return btoa(utf8Encode(input));
        } : function(input) {
            var output = "";
            var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
            var i = 0;
            input = utf8Encode(input);
            while (i < input.length) {
                chr1 = input.charCodeAt(i++);
                chr2 = input.charCodeAt(i++);
                chr3 = input.charCodeAt(i++);
                enc1 = chr1 >> 2;
                enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
                enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                enc4 = chr3 & 63;
                if (isNaN(chr2)) {
                    enc3 = enc4 = 64;
                } else if (isNaN(chr3)) {
                    enc4 = 64;
                }
                output = output +
                    keyStr.charAt(enc1) + keyStr.charAt(enc2) +
                    keyStr.charAt(enc3) + keyStr.charAt(enc4);
            }
            return output;
        }
    };
})();
 
Ext.define('MyApp.view.override.Grid', {
    override: 'Ext.grid.GridPanel',
 
 
    /*
        Kick off process
    */
    downloadExcelXml: function(includeHidden, title) {
  		if(this.getStore().getCount() < 1 ) return;
    	
        if (!title) title = this.title;
 
        if (Ext.isEmpty(title)) {
        	title = this.id ? this.id : 'Export';
        }
        var vExportContent = this.getExcelXml(includeHidden, title);
 
        var location = 'data:application/vnd.ms-excel;base64,' + Base64.encode(vExportContent);
 
        /* 
          dynamically create and anchor tag to force download with suggested filename 
          note: download attribute is Google Chrome specific
        */
 
        var fileName = title + "-" + Ext.Date.format(new Date(), 'Y-m-d Hi') + '.xls';
        
        if (true && (Ext.isChrome || Ext.isGecko || Ext.isSafari)) { // local download
            var gridEl = this.getEl();
 
            var el = Ext.DomHelper.append(gridEl, {
                tag: "a",
                download: fileName,
                href: location
            });
 
            el.click();
 
            Ext.fly(el).destroy();
 
        } else { // remote download
 
            var form = this.down('form#uploadForm');
            if (form) {
                form.destroy();
            }
            form = this.add({
                xtype: 'form',
                itemId: 'uploadForm',
                hidden: true,
                standardSubmit: true,
                url: CPATH+'/download/echoExcel.do',
                items: [{
                    xtype: 'hiddenfield',
                    name: 'data',
                    value: vExportContent
                },{
                    xtype: 'hiddenfield',
                    name: 'fileName',
                    value: fileName
                }]
            });
 
            form.getForm().submit();
        }
    },
 
 
    /*
     
        Welcome to XML Hell
        See: http://msdn.microsoft.com/en-us/library/office/aa140066(v=office.10).aspx
        for more details
 
    */
    getExcelXml: function(includeHidden, title) {

        var theTitle = title || this.title;
        
        var worksheet = this.createWorksheet(includeHidden, theTitle);        
        var totalWidth = this.columns.length;
		//<?xml version="1.0" encoding="utf-8" ?>
        return ''.concat(
            '<?xml version="1.0" encoding="utf-8"?>',
            //'<?mso-application progid="Excel.Sheet"?>',
            '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">',
            '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office"><Title>' + theTitle + '</Title></DocumentProperties>',
            '<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office"><AllowPNG/></OfficeDocumentSettings>',
            '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">',
            '<WindowHeight>' + worksheet.height + '</WindowHeight>',
            '<WindowWidth>' + worksheet.width + '</WindowWidth>',
            '<ProtectStructure>False</ProtectStructure>',
            '<ProtectWindows>False</ProtectWindows>',
            '</ExcelWorkbook>',

            '<Styles>',

            '<Style ss:ID="Default" ss:Name="Normal">',
            '<Alignment ss:Vertical="Bottom"/>',
            '<Borders/>',
            '<Font ss:FontName="맑은 고딕" x:Family="Modern" ss:Size="11" ss:Color="#000000"/>',
            '<Interior/>',
            '<NumberFormat/>',
            '<Protection/>',
            '</Style>',
            
			  '<Style ss:ID="uniPercent" ss:Name="백분율">',
			  '<NumberFormat ss:Format="0%"/>',
			  '</Style>',
              
			  '<Style ss:ID="s17" ss:Name="쉼표 [0]">',
			  '<NumberFormat ss:Format="_-* #,##0_-;\-* #,##0_-;_-* &quot;-&quot;_-;_-@_-"/>',
			  '</Style>',
              
            '<Style ss:ID="title">',
            '<Borders />',
            '<Font ss:Bold="1" ss:Size="18" />',
            '<Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1" />',
            '<NumberFormat ss:Format="@" />',
            '</Style>',

            '<Style ss:ID="headercell">',
            '<Font ss:Bold="1" ss:Size="11" />',
            '<Alignment ss:Horizontal="Center" ss:WrapText="1" />',
            '<Interior ss:Color="#A3C9F1" ss:Pattern="Solid" />',
            '</Style>',


            '<Style ss:ID="even">',
            '<Interior/>',
            '</Style>',


            '<Style ss:ID="uniDate" ss:Parent="even">',
            '<NumberFormat ss:Format="yyyy-mm-dd" />',
            '</Style>',


            '<Style ss:ID="uniInt" ss:Parent="s17">',
            '<Numberformat ss:Format="0" />',
            '</Style>',

            '<Style ss:ID="uniFloat" ss:Parent="s17">',
            '<Numberformat ss:Format="0.00" />',
            '</Style>',

            '<Style ss:ID="groupSeparator">',
            '<Interior ss:Color="#D3D3D3" ss:Pattern="Solid" />',
            '</Style>',

            '</Styles>',
            worksheet.xml,
            '</Workbook>'
        );
    },
 
    /*
     
        Support function to return field info from store based on fieldname
     
    */
 
    getModelField: function(fieldName) {
 
        var fields = this.store.model.getFields();
        for (var i = 0; i < fields.length; i++) {
            if (fields[i].name === fieldName) {
                return fields[i];
            }
        }
    },
 
    /*
         
        Convert store into Excel Worksheet
 
    */

     generateEmptyGroupRow: function(dataIndex, value, cellTypes, includeHidden) {

        
        //var cm =  this.getView().getGridColumns();
     	var cm =  this.getColumns();
        var colCount = this.columns.length;
        var rowTpl = '<Row ss:AutoFitHeight="0"><Cell ss:StyleID="groupSeparator" ss:MergeAcross="{0}"><Data ss:Type="String"><html:b>{1}</html:b></Data></Cell></Row>';
        var visibleCols = 0;
        
        // rowXml += '<Cell ss:StyleID="groupSeparator">'
        
        for (var j = 0; j < colCount; j++) {
            if (cm[j].xtype != 'actioncolumn' && (cm[j].dataIndex != '') && (includeHidden || !cm[j].hidden)) {
                // rowXml += '<Cell ss:StyleID="groupSeparator"/>';
                visibleCols++;
            }
        }
        
        // rowXml += "</Row>";
        
        return Ext.String.format(rowTpl,visibleCols - 1,value);
    }, 
    
    createWorksheet: function(includeHidden, theTitle) {
        // Calculate cell data types and extra class names which affect formatting
        var cellType = [];
        var cellTypeClass = [];
//        var cm = this.columns;
        var cm = this.getView().getGridColumns();
        
        var totalWidthInPixels = 0;
        var colXml = '';
        var headerXml = '';
        var visibleColumnCountReduction = 0;
        var colCount = cm.length;
        for (var i = 0; i < colCount; i++) {
            if (cm[i].xtype != 'actioncolumn' && cm[i].xtype != 'rownumberer' && (cm[i].dataIndex != '') && (includeHidden || !cm[i].hidden)) {
                var w = cm[i].getEl().getWidth();
                totalWidthInPixels += w;

                if (cm[i].text === "") {
                    cellType.push("None");
                    cellTypeClass.push("");
                    ++visibleColumnCountReduction;
                } else {
                    colXml += '<Column ss:AutoFitWidth="1" ss:Width="' + w + '" />';
                    headerXml += '<Cell ss:StyleID="headercell">' +
                        '<Data ss:Type="String">' + cm[i].text + '</Data>' +
                        '<NamedCell ss:Name="Print_Titles"></NamedCell></Cell>';


                    var fld = this.getModelField(cm[i].dataIndex);
                    if(fld) {
	                    switch (fld.type.type) {
	                        case "int":
	                            cellType.push("Number");
	                            cellTypeClass.push("uniInt");
	                            break;
                            case "uniPrice":
	                        case "float":
	                            cellType.push("Number");
	                            cellTypeClass.push("uniFloat");
	                            break;
                            case "uniPercent":
                                cellType.push("Number");
                                cellTypeClass.push("uniPercent");
                                break;
                            case "float":
                                cellType.push("Number");
                                cellTypeClass.push("uniFloat");
                                break;
	
	                        case "bool":
	
	                        case "boolean":
	                            cellType.push("String");
	                            cellTypeClass.push("");
	                            break;
                            case "uniDate":
	                        case "date":
	                            cellType.push("DateTime");
	                            cellTypeClass.push("uniDate");
	                            break;
	                        default:
	                            cellType.push("String");
	                            cellTypeClass.push("");
	                            break;
	                    }
                    } else {
                    	cellType.push("String");
                        cellTypeClass.push("");
                    }
                }
            }
        }
        var visibleColumnCount = cellType.length - visibleColumnCountReduction;

        var result = {
            height: 9000,
            width: Math.floor(totalWidthInPixels * 30) + 50
        };

        // Generate worksheet header details.

        // determine number of rows
        var numGridRows = this.store.getCount() + 2;
        if (!Ext.isEmpty(this.store.groupField)) {
            numGridRows = numGridRows + this.store.getGroups().length;
        }

        // create header for worksheet
        var t = ''.concat(
            '<Worksheet ss:Name="' + theTitle + '">',

            '<Names>',
            '<NamedRange ss:Name="Print_Titles" ss:RefersTo="=\'' + theTitle + '\'!R1:R2">',
            '</NamedRange></Names>',

            '<Table ss:ExpandedColumnCount="' + (visibleColumnCount + 2),
            '" ss:ExpandedRowCount="' + numGridRows + '" x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">',
            colXml,
            '<Row ss:Height="38">',
            '<Cell ss:MergeAcross="' + (visibleColumnCount - 1) + '" ss:StyleID="title">',
            '<Data ss:Type="String" xmlns:html="http://www.w3.org/TR/REC-html40">',
            '<html:b>' + theTitle + '</html:b></Data><NamedCell ss:Name="Print_Titles">',
            '</NamedCell></Cell>',
            '</Row>',
            '<Row ss:AutoFitHeight="1">',
            headerXml +
            '</Row>'
        );

        // Generate the data rows from the data in the Store
        var groupVal = "";
        for (var i = 0, it = this.store.data.items, l = it.length; i < l; i++) {

            if (this.uniOpt.excel.exportGroup && !Ext.isEmpty(this.store.groupField)) {
                if (groupVal != this.store.getAt(i).get(this.store.groupField)) {
                    groupVal = this.store.getAt(i).get(this.store.groupField);
                    t += this.generateEmptyGroupRow(this.store.groupField, groupVal, cellType, includeHidden);
                }
            }
            t += '<Row>';
            //var cellClass = (i & 1) ? 'odd' : 'even';
            r = it[i].data;
            var k = 0;
            for (var j = 0; j < colCount; j++) {
                if (cm[j].xtype != 'actioncolumn' && cm[j].xtype != 'rownumberer' &&  (cm[j].dataIndex != '') && (includeHidden || !cm[j].hidden)) {
                    var v = cm[j].dataIndex ? r[cm[j].dataIndex] : '';
                    if (cellType[k] !== "None") {
                        
                        if(Ext.isEmpty(cellTypeClass[k]) ) {
                            t += '<Cell ><Data ss:Type="' + cellType[k] + '">';
                        } else {
                            t += '<Cell ss:StyleID="' + cellTypeClass[k] + '"><Data ss:Type="' + cellType[k] + '">';
                        }
                        
                        //t += '<Cell ss:StyleID="' + cellClass + cellTypeClass[k] + '"><Data ss:Type="' + cellType[k] + '">';
                        if (cellType[k] == 'DateTime') {
                            t += Ext.Date.format(v, 'Y-m-d');
                        } else if (cellType[k] == 'Number' && cellTypeClass[k] == 'uniPercent') {
                                t += (v / 100);
                           
                        }  else {
                            t += v;
                        }
                        t += '</Data></Cell>';
                    }
                    k++;
                }
            }
            t += '</Row>';
        }

        result.xml = t.concat(
            '</Table>',
            '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">',
            '<PageLayoutZoom>0</PageLayoutZoom>',
            '<Selected/>',
            '<Panes>',
            '<Pane>',
            '<Number>3</Number>',
            '<ActiveRow>2</ActiveRow>',
            '</Pane>',
            '</Panes>',
            '<ProtectObjects>False</ProtectObjects>',
            '<ProtectScenarios>False</ProtectScenarios>',
            '</WorksheetOptions>',
            '</Worksheet>'
        );
        return result;
    }
});