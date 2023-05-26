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
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniTreeStore.js" />' ></script>
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/data/UniTreeModel.js" />' ></script>
	
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
	<script type="text/javascript" charset="UTF-8" src='<c:url value="/${ext_root}/app/Unilite/com/grid/UniTreeGridPanel.js" />' ></script>
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
		Ext.define("UniFormat", {
	    		singleton: true,
			 	Qty: 			'0,000', //						// 수량
			    UnitPrice: 		'0,000.00',		// "${loginVO.userID}",		// 단가
			    Price: 			'0,000',		// "${loginVO.userName}",		// 금액
			    FC: 			'0,000.00',  	// "${loginVO.personNumb}",	// 외화
			    ER: 			'0,000.00',  	//  ${loginVO.personNumb}",	// 환율
			    Percent: 		'0,000.00',		// "${loginVO.userID}",		// 확률
	 			FDATE:			'Y-m-d', 		//  "${loginVO.fDate}",			// 날자
			    FYM: 			'Y-m' //"${loginVO.fYM}"			// 연월
			 }
		);
        Ext.onReady(function(){
        	Ext.tip.QuickTipManager.init();
        	Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
        	
        	//Unilite.defineTreeModel('bsa400ukrvModel', {
        	Ext.define('bsa400ukrvModel', {
        		extend: 'Ext.data.TreeModel',
				// pkGen : user, system(default)
			    fields: [ 	 {name: 'parentId' 		,text:'상위소속' 			,type:'string'	 ,editable:false   }
			    			,{name: 'PGM_ID' 		,text:'PGM_ID' 			,type:'string'	 ,allowBlank:false 	,isPk:true	}
			    			,{name: 'PGM_NAME' 		,text:'프로그램명' 			,type:'string'	 ,allowBlank:false }
			    			
			    			
					]
			});
			
			var directMasterStore = Unilite.createTreeStore('bsa400ukrvMasterStore',{
			//var directMasterStore = Ext.create('Ext.data.TreeStore', {
				model: 'bsa400ukrvModel',
	            autoLoad: false,
	            folderSort: true,
	            //---------------------------------------------------------------------------
	            //중요!! 5.1에서 root 설정을 안해주면 load 후 root를 expand 해줘야 그리드에 트리노드들이 보여진다.(bug??)
	            root: {
				    expanded: false,
				    children: []
				},
				//--------------------------------------------------------------------------
	            proxy: {
	                type: 'direct',
	                api: {
		                read : 'bsa400ukrvService.selectList'
		                ,update : 'bsa400ukrvService.updatePrograms'
						,create : 'bsa400ukrvService.insertPrograms'
						,destroy: 'bsa400ukrvService.deletePrograms'
						,syncAll: 'bsa400ukrvService.syncAll'
	                	
	                }
	            },
	            listeners: {
	            	'load' : function( store, records, successful, operation, node, eOpts) {
	            		if(records) {
	            			var root = this.getRoot();
	            			if(root) {
	            				root.expandChildren();
	            			}
	            		}
	            	}
	            }
				// Store 관련 BL 로직
	            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
				,loadStoreRecords : function()	{
					var param = {PGM_SEQ:'', PGM_ID:'', PGM_NAME:''};  
					this.load({
						params : param
					});
				}
			});
			
			//var masterGrid = Unilite.createTreeGrid('bsa400ukrvGrid', {
			var masterGrid = Ext.create('Ext.tree.Panel', {
		    	store: directMasterStore,
		    	rootVisible: false,
		    	flex: 1,
		    	maxDepth : 3,
				columns:[{
				                xtype: 'treecolumn', //this is so we know which column will show the tree
				                text: '프로그램명',
				                width:250,
				                sortable: true,
				                dataIndex: 'PGM_NAME', editable: false 
				         }				 
						,{dataIndex:'PGM_ID'		,text:'PGM_ID' 	,width:90	}
						,{dataIndex:'PGM_NAME'		,text:'프로그램명'	,width:250}	
						
		          ] 		         
		    });
        	
        	/*var store = Ext.create('Ext.data.TreeStore', {
			    root: {
			        //expanded: true,
			        children: [
			            { text: "detention", leaf: true },
			            { text: "homework", expanded: true, children: [
			                { text: "book report", leaf: true },
			                { text: "algebra", leaf: true}
			            ] },
			            { text: "buy lottery tickets", leaf: true }
			        ]
			    }
			});
			
			var masterGrid = Ext.create('Ext.tree.Panel', {
			    title: 'Simple Tree',
			    width: 200,
			    height: 150,
			    store: store,
			    rootVisible: false
			});*/
			
			
			/*var data = {
				    "text": ".",
				    "children": [
				        {
				            "task": "Project: Shopping",
				            "duration": 13.25,
				            "user": "Tommy Maintz",
				            "iconCls": "task-folder",
				            "expanded": true,
				            "children": [
				                {
				                    "task": "Housewares",
				                    "duration": 1.25,
				                    "user": "Tommy Maintz",
				                    "iconCls": "task-folder",
				                    "children": [
				                        {
				                            "task": "Kitchen supplies",
				                            "duration": 0.25,
				                            "user": "Tommy Maintz",
				                            "leaf": true,
				                            "iconCls": "task"
				                        }, {
				                            "task": "Groceries",
				                            "duration": .4,
				                            "user": "Tommy Maintz",
				                            "leaf": true,
				                            "iconCls": "task",
				                            "done": true
				                        }, {
				                            "task": "Cleaning supplies",
				                            "duration": .4,
				                            "user": "Tommy Maintz",
				                            "leaf": true,
				                            "iconCls": "task"
				                        }, {
				                            "task": "Office supplies",
				                            "duration": .2,
				                            "user": "Tommy Maintz",
				                            "leaf": true,
				                            "iconCls": "task"
				                        }
				                    ]
				                }, {
				                    "task": "Remodeling",
				                    "duration": 12,
				                    "user": "Tommy Maintz",
				                    "iconCls": "task-folder",
				                    "expanded": true,
				                    "children": [
				                        {
				                            "task": "Retile kitchen",
				                            "duration": 6.5,
				                            "user": "Tommy Maintz",
				                            "leaf": true,
				                            "iconCls": "task"
				                        }, {
				                            "task": "Paint bedroom",
				                            "duration": 2.75,
				                            "user": "Tommy Maintz",
				                            "iconCls": "task-folder",
				                            "children": [
				                                {
				                                    "task": "Ceiling",
				                                    "duration": 1.25,
				                                    "user": "Tommy Maintz",
				                                    "iconCls": "task",
				                                    "leaf": true
				                                }, {
				                                    "task": "Walls",
				                                    "duration": 1.5,
				                                    "user": "Tommy Maintz",
				                                    "iconCls": "task",
				                                    "leaf": true
				                                }
				                            ]
				                        }, {
				                            "task": "Decorate living room",
				                            "duration": 2.75,
				                            "user": "Tommy Maintz",
				                            "leaf": true,
				                            "iconCls": "task",
				                            "done": true
				                        }, {
				                            "task": "Fix lights",
				                            "duration": .75,
				                            "user": "Tommy Maintz",
				                            "leaf": true,
				                            "iconCls": "task",
				                            "done": true
				                        }, {
				                            "task": "Reattach screen door",
				                            "duration": 2,
				                            "user": "Tommy Maintz",
				                            "leaf": true,
				                            "iconCls": "task"
				                        }
				                    ]
				                }
				            ]
				        }, {
				            "task": "Project: Testing",
				            "duration": 2,
				            "user": "Core Team",
				            "iconCls": "task-folder",
				            "children": [
				                {
				                    "task": "Mac OSX",
				                    "duration": 0.75,
				                    "user": "Tommy Maintz",
				                    "iconCls": "task-folder",
				                    "children": [
				                        {
				                            "task": "FireFox",
				                            "duration": 0.25,
				                            "user": "Tommy Maintz",
				                            "iconCls": "task",
				                            "leaf": true
				                        }, {
				                            "task": "Safari",
				                            "duration": 0.25,
				                            "user": "Tommy Maintz",
				                            "iconCls": "task",
				                            "leaf": true
				                        }, {
				                            "task": "Chrome",
				                            "duration": 0.25,
				                            "user": "Tommy Maintz",
				                            "iconCls": "task",
				                            "leaf": true
				                        }
				                    ]
				                }, {
				                    "task": "Windows",
				                    "duration": 3.75,
				                    "user": "Darrell Meyer",
				                    "iconCls": "task-folder",
				                    "children": [
				                        {
				                            "task": "FireFox",
				                            "duration": 0.25,
				                            "user": "Darrell Meyer",
				                            "iconCls": "task",
				                            "leaf": true
				                        }, {
				                            "task": "Safari",
				                            "duration": 0.25,
				                            "user": "Darrell Meyer",
				                            "iconCls": "task",
				                            "leaf": true
				                        }, {
				                            "task": "Chrome",
				                            "duration": 0.25,
				                            "user": "Darrell Meyer",
				                            "iconCls": "task",
				                            "leaf": true
				                        }, {
				                            "task": "Internet Explorer",
				                            "duration": 3,
				                            "user": "Darrell Meyer",
				                            "iconCls": "task",
				                            "leaf": true
				                        }
				                    ]
				                }, {
				                    "task": "Linux",
				                    "duration": 0.5,
				                    "user": "Aaron Conran",
				                    "iconCls": "task-folder",
				                    "children": [
				                        {
				                            "task": "FireFox",
				                            "duration": 0.25,
				                            "user": "Aaron Conran",
				                            "iconCls": "task",
				                            "leaf": true
				                        }, {
				                            "task": "Chrome",
				                            "duration": 0.25,
				                            "user": "Aaron Conran",
				                            "iconCls": "task",
				                            "leaf": true
				                        }
				                    ]
				                }
				            ]
				        }
				    ]
				};
			Ext.define('KitchenSink.model.tree.Task', {
			    extend: 'Ext.data.Model',
			    fields: [{
			        name: 'task',
			        type: 'string'
			    }, {
			        name: 'user',
			        type: 'string'
			    }, {
			        name: 'duration',
			        type: 'float'
			    }, {
			        name: 'done',
			        type: 'boolean'
			    }]
			}); 
			var directMasterStore = new Ext.data.TreeStore({
			                model: 'KitchenSink.model.tree.Task',
			                //data: data,
			                proxy: {
						        type: 'memory',
						        reader: {
						            type: 'json'
						            //,rootProperty: 'users'
						        }
						    },
			                folderSort: true,
			                autoLoad: false,
            	            listeners: {
				            	'load' : function( store, records, successful, operation, node, eOpts) {
				            		if(records) {
				            			var root = this.getRoot();
				            			if(root) {
				            				root.expandChildren();
				            			}
				            		}
				            	}
				            }
			            });
			Ext.define('KitchenSink.view.tree.TreeGrid', {
			    extend: 'Ext.tree.Panel',
			    
			    requires: [
			        'Ext.data.*',
			        'Ext.grid.*',
			        'Ext.tree.*',
			        'Ext.ux.CheckColumn'
			    ],    
			    xtype: 'tree-grid',
			    
			    reserveScrollbar: true,
			    
			    title: 'Core Team Projects',
			    height: 370,
			    useArrows: true,
			    rootVisible: false,
			    multiSelect: true,
			    singleExpand: true,
			    
			    initComponent: function() {
			        this.width = 600;
			        
			        Ext.apply(this, {
			            store: directMasterStore,
			            columns: [{
			                xtype: 'treecolumn', //this is so we know which column will show the tree
			                text: 'Task',
			                flex: 2,
			                sortable: true,
			                dataIndex: 'task'
			            },{
			                //we must use the templateheader component so we can use a custom tpl
			                xtype: 'templatecolumn',
			                text: 'Duration',
			                flex: 1,
			                sortable: true,
			                dataIndex: 'duration',
			                align: 'center',
			                //add in the custom tpl for the rows
			                tpl: Ext.create('Ext.XTemplate', '{duration:this.formatHours}', {
			                    formatHours: function(v) {
			                        if (v < 1) {
			                            return Math.round(v * 60) + ' mins';
			                        } else if (Math.floor(v) !== v) {
			                            var min = v - Math.floor(v);
			                            return Math.floor(v) + 'h ' + Math.round(min * 60) + 'm';
			                        } else {
			                            return v + ' hour' + (v === 1 ? '' : 's');
			                        }
			                    }
			                })
			            },{
			                text: 'Assigned To',
			                flex: 1,
			                dataIndex: 'user',
			                sortable: true
			            }, {
			                xtype: 'checkcolumn',
			                header: 'Done',
			                dataIndex: 'done',
			                width: 55,
			                stopSelection: false,
			                menuDisabled: true
			            }, {
			                text: 'Edit',
			                width: 55,
			                menuDisabled: true,
			                xtype: 'actioncolumn',
			                tooltip: 'Edit task',
			                align: 'center',
			                icon: 'resources/images/edit_task.png',
			                handler: function(grid, rowIndex, colIndex, actionItem, event, record, row) {
			                    Ext.Msg.alert('Editing' + (record.get('done') ? ' completed task' : '') , record.get('task'));
			                },
			                // Only leaf level tasks may be edited
			                isDisabled: function(view, rowIdx, colIdx, item, record) {
			                    return !record.data.leaf;
			                }
			            }]
			        });
			        this.callParent();
			    }
			});		*/
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
		        	masterGrid,
		        	{
			        	xtype: 'button',
			        	text: 'search',
			        	handler: function(){
			        		directMasterStore.loadStoreRecords();
			        		//directMasterStore.loadRawData(data);
			        	}
			        }
			        //,Ext.create('KitchenSink.view.tree.TreeGrid')
		        ]
		    });
        });
    </script>
    <!-- </x-compile> -->
</head>
<body>
</body>
</html>
