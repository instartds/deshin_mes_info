<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="java.util.*" %>
<%@page import="org.apache.poi.ss.usermodel.*" %>
<%@page import="foren.unilite.com.excel.vo.*" %>
<%@page import="foren.unilite.com.excel.*" %>
<%@page import="foren.framework.utils.*" %>
<%@page import="foren.framework.utils.*" %>
<%@ taglib prefix="t" uri="/WEB-INF/tld/tLab.tld"%>
<%
//	String workBookName = "sof100";
//	ExcelUploadService excelGen = (ExcelUploadService) ObjUtils.getBean(ExcelUploadService.SERVICE_BEAN_ID);
//	ExcelUploadWorkBookVO excelConfig = excelGen.getExcelConfig(workBookName);
//	List<ExcelUploadSheetVO> sheetList = excelConfig.getSheetList();
//	request.setAttribute("excelConfigName", workBookName);
	//request.setAttribute("workBookInfo", excelGen.genExtExcelInfo(workBookName));
%>
<script type="text/javascript">



	
	Ext.onReady(function() {
		Unilite.Excel.defineModel('excel.sof100.sheet01', {
		    fields: [
		             {name: 'ITEM_CODE',  text:'', type: 'string'},
		             {name: 'QTY',  text:'수량', type: 'int'}
		    ]
		});
		function getNewEventEditor() {
		        var me = this;
		        var vParam = {};
		        var appName = 'Unilite.com.excel.ExcelUploadWin';

                var oWin =  Ext.WindowMgr.get(appName);
                if(!oWin) {
                	
                    oWin = Ext.create( appName, {
                    		excelConfigName: 'sof100',
                    		extParam: { 'myName': 'foren' },
                            grids: [
                            	 {
                            		itemId: 'grid01',
                            		title: '수주정보',
                            		
                            		useCheckbox: true,
                            		model : 'excel.sof100.sheet01',
                            		readApi: 'sof100ukrvService.selectExcelUploadSheet1',
                            		columns: [
                                 		     { dataIndex:'ITEM_CODE'},
                                		     { dataIndex:'QTY'},
                            		]
                            	},
                            	{
                            		itemId: 'grid02',
                            		title: '수주정보2',
                            		model : 'excel.sof100.sheet01',
                            		readApi: 'sof100ukrvService.selectExcelUploadSheet1',
                            		columns: [
                                 		     { dataIndex:'ITEM_CODE'},
                                		     { dataIndex:'QTY'}
                            		]
                            	}
                            ],
                            listeners: {
                                close: function() {
                                    //me.refresh(true);
                                }
                            }
                     });
                }
                oWin.center();
                oWin.show();
		};
		           
		    
		var excelForm = {
			xtype : 'form',
            fileUpload: true,
	        layout: { 
                type: 'table', 
                columns: 2,
	        	tableAttrs: {
	          		style: { width: '100%' }
                }
            },
			items : [ 
				{	
					xtype:'button',
					text: 'Excel Upload',
					handler: function() {
						getNewEventEditor();
					}
				}
			]
		};
		

		var app = Ext.create('Unilite.com.BaseApp', {
			items : [ excelForm ],
			onQueryButtonDown:function() {
				var form = Ext.getCmp('searchForm');
	            console.log(form.getValues());
			},
            onSaveDataButtonDown: function (config) {
	            var fileForm = excelForm.getForm();
	            if(fileForm.isDirty())  {
	                fileForm.submit({ 
	                            waitMsg: 'Uploading...',
	                            success: function(form, action) {
	                                if( action.result.success === true) {
	                                    
	                                }
	                            }
	                    });
	            }else {
	                masterGrid.getStore().saveStore(config);
	            }
	            
	        }
		});

	});
	
    

</script>