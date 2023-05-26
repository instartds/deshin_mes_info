<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
    request.setAttribute("ext_url", "/extjs5/ext-all-debug_5.1.0.js");
	
	//request.setAttribute("css_url", "/extjs/resources/ext-theme-classic/ext-theme-classic-all-debug.css"); // 4.2.2
    request.setAttribute("css_url", "/extjs5/resources/ext-theme-classic-omega/ext-overrides.css"); // 5.1.0    
    request.setAttribute("ext_root", "extjs5"); // 5.1.0
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Edit Grid Sample</title>

	<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/ux-overrides.css" />' />
	<link rel="stylesheet" type="text/css" href='<c:url value="/resources/css/unilite_5.1.0.css" />' />
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url }" />'></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Ext/overrides/ext-bug-overrides.js" />' ></script>
	

    <script type="text/javascript">
    	var CPATH ='<%=request.getContextPath()%>';
        Ext.Loader.setConfig({
		enabled : true,
		scriptCharset : 'UTF-8',
		paths: {
                "Ext": '${CPATH }/${ext_root}/src',
            	"Ext.ux": '${CPATH }/${ext_root}/app/Ext/ux',
            	"Unilite": '${CPATH }/${ext_root}/app/Unilite',
            	"Extensible": '${CPATH }/${ext_root}/app/Extensible'
        }
	});
	Ext.require('*');	
    </script>
    
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniUtils.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniTypes.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/Unilite.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/UniDate.js"/>' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/UniAppManager.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniAbstractStore.js" />' ></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniStore.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniModel.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/button/BaseButton.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniBaseField.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniClearButton.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniComboBox.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/form/field/UniTextField.js" />' ></script>
	

	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniFields.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniDateColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniTimeColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniPriceColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/column/UniNumberColumn.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniAbstractGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniGridPanel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/excel/Excel.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/feature/UniGroupingSummary.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/feature/UniSummary.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/Message-ko.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/locale/unilite-lang-ko.js" />'> </script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/locale/ext-lang-ko.js" />' ></script>
	
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/api.js" />'></script>
	
    <script type="text/javascript">   
		
		Ext.require([
		    'Ext.data.*',
		    'Ext.tip.QuickTipManager',
		    'Ext.window.MessageBox'
		]);
		
		
		
        Ext.onReady(function(){
        	Ext.tip.QuickTipManager.init();
        	Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
        	
        	
        	
        	
        	var cbStore = Ext.create('Ext.data.Store',{"comboType":"BOR120","comboCode":"","storeId":"CBS_BOR120_","fields":["value","text","option","search","refCode1","refCode2","refCode3","refCode4","refCode5","refCode6","refCode7","refCode8","refCode9","refCode10"],"data":[{"value":"01","text":"서울 캠퍼스","option":null,"search":"01서울 캠퍼스"},{"value":"02","text":"원주 캠퍼스","option":null,"search":"02원주 캠퍼스"}]});
        	
        	//Unilite.defineModel('bpr100ukrvModel', {
        	Ext.define('bpr100ukrvModel', {
        		extend: 'Ext.data.Model',
		    	fields: [ 
		    		 { name: 'ITEM_CODE',  			text: '품목코드', 		type : 'string'}      
			  		,{ name: 'ITEM_NAME',  			text: '품목명', 		type : 'string'}        
			  		,{ name: 'ITEM_NAME1',  		text: '품목명1', 		type : 'string'}       
			  		,{ name: 'ITEM_NAME2',  		text: '품목명2', 		type : 'string'}       
			  		,{ name: 'SPEC',  				text: '규격', 		type : 'string'}          
			  		,{ name: 'STOCK_UNIT',  		text: '재고단위', 		type : 'string'}      
				    ,{ name: 'ITEM_SIZE',  			text: '사이즈', 		type : 'string'}        
//					,{ name: 'DIV_CODE',  				text: '사업장', 		type : 'string', maxLength: 80, allowBlank: false, 
//						//comboType: 'BOR120', 
//						store: cbStore, multiSelect: true, typeAhead: false}
				]
			});        	
			
			//var store1 = Unilite.createStore('bpr100ukrvMasterStore',{
			var store1 = Ext.create('Ext.data.Store',{
				model: 'bpr100ukrvModel',
	           	autoLoad: true,
	        	uniOpt : {
	            	isMaster: false,			// 상위 버튼 연결 
	            	editable: true,			// 수정 모드 사용 
	            	deletable:true,			// 삭제 가능 여부 
		            useNavi : false			// prev | newxt 버튼 사용
	            },
	           	proxy: {
	               type: 'direct',
	               api: {
		               	read: 'bpr100ukrvService.selectDetailList'
	               }
	            }
			});
	        
	        //var masterGrid = Unilite.createGrid('bpr100ukrvGrid', {
	        //var masterGrid = Ext.create('Unilite.com.grid.UniGridPanel', {	
			var masterGrid = Ext.create('Ext.grid.Panel', {
		    	//region:'center',
	        	//id: 'bpr100ukrvGrid',
		    	store : store1,
		    	sortableColumns : false,
		    	selType: 'rowmodel',
		    	flex: 1,
//		    	requires: [
//			        'Ext.grid.plugin.CellEditing',
//			        'Ext.form.field.Text',
//			        'Ext.toolbar.TextItem'
//			    ],
		    	plugins: [Ext.create('Ext.grid.plugin.CellEditing')],
//		        plugins: {
//			        ptype: 'bufferedrenderer',
//			        trailingBufferZone: 20,  // Keep 20 rows rendered in the table behind scroll
//			        leadingBufferZone: 20   // 결과셋의 수에 따라 늘려야 신규입력 시 포커스 문제가 안생김
//			    },		    	
		    	dockedItems: [{
	                xtype: 'toolbar',
	                items: [{
	                    text: 'Add',
	                    scope: this,
	                    handler: function() {
	                    	//masterGrid.createRow();
	                    	var rec = new bpr100ukrvModel({
					            ITEM_CODE: '',
					            ITEM_NAME: '',
					            ITEM_NAME1: '',
					            ITEM_NAME2: '',
					            SPEC: '',
					            STOCK_UNIT: '',
					            ITEM_SIZE: ''
					        })
//	                    	var rec = new Writer.Person({
//					            first: '',
//					            last: '',
//					            email: ''
//					        })
//	                    	var	newRecord =  Ext.create (directMasterStore.model, values);
		
		        			//masterGrid.editing.cancelEdit();
							newRecord = store1.insert(0, rec);	
	                    }
	                },{
	                    text: 'Delete',
	                    disabled: true,
	                    itemId: 'delete',
	                    scope: this,
	                    handler: function() {
	                    	masterGrid.deleteSelectedRow();
	                    }
	                },{
	                    text: 'Excel',
	                    itemId: 'excel',
	                    scope: this,
	                    handler: function() {
	                    	masterGrid.downloadExcelXml();
	                    }
	                }]
	            }],
		        columns:  [    
		        	{ dataIndex: 'ITEM_CODE',  	text: '품목코드', 	width: 160		,locked: true
		        	 	,editor: {
			                xtype: 'textfield',
			                allowBlank: false
			            }
			         }        
			  		,{ dataIndex: 'ITEM_NAME',  	text: '품목명', 	width: 140		,locked: true
			  			,editor: {
			                xtype: 'textfield',
			                allowBlank: false
			            }
			  		 }        
			  		,{ dataIndex: 'ITEM_NAME1',  	text: '품목명1', 	width: 140		,hidden:true}        
			  		,{ dataIndex: 'ITEM_NAME2',  	text: '품목명2', 	width: 140		,hidden:true}        
			  		,{ dataIndex: 'SPEC',  			text: '규격',		width: 170		
			  			,editor: {
			                xtype: 'textfield',
			                allowBlank: false
			            }
			  		 
			  		}    
			  		,{ dataIndex: 'STOCK_UNIT',  	text: '재고단위',	width: 120, 	align: 'center'		
			  			,editor: {
			                xtype: 'textfield',
			                allowBlank: false
			            }
			  		 }          
				    ,{ dataIndex: 'ITEM_SIZE',  	text: '사이즈',	width: 120		
				    	,editor: {
			                xtype: 'textfield'
			            }
				     }
//					,{ dataIndex: 'DIV_CODE',  	text: 'COMBO	',	width: 120		
//				    	,editor: {
//			                xtype: 'uniCombobox',
//			                multiSelect: true,
//			                typeAhead: false,
//			                store: cbStore
//			            }
//				     }  		   
		        ],
		        listeners: {
		        	beforeselect: function( grid, record, index, eOpts ) {
		        		if(grid.getLastSelected()!==record) {
		        			console.log('selection change');
		        		}
		        		console.log('record:', record);
		        	},
		        	select: function( grid, record, index, eOpts ) {
		        		console.log('record:', record);
		        	},
		        	selectionchange: function( grid, selected, eOpts ) {
		        		console.log('selected:', selected);	
		        	},
		        	rowclick: function( grid, record, tr, rowIndex, e, eOpts ) {
		        		console.log('record:', record);	
		        	}
		        }
		    });
		
		    var main = Ext.create('Ext.container.Container', {
		        padding: '0 0 0 20',
		        width: 1000,
		        height: Ext.themeName === 'neptune' ? 500 : 450,
		        renderTo: document.body,
		        layout: {
		            type: 'vbox',
		            align: 'stretch'
		        },
		        items: [
		        	masterGrid
		        ]
		    });
        });
    </script>
    <!-- </x-compile> -->
</head>
<body>
</body>
</html>
