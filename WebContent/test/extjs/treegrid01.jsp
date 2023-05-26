<%@page language="java" contentType="text/html; charset=utf-8"%>

<script type="text/javascript">
    
	Ext.onReady(function() {
		
		Ext.define('deptModel', {
		    extend: 'Ext.data.Model',
		    fields: [{
		        name: 'treeName',
		        type: 'string',
		        text: '부서명'
		    }, {
		        name: 'treeCode',
		        type: 'string'
		    }, {
		        name: 'duration',
		        type: 'float'
		    }, {
		        name: 'done',
		        type: 'boolean'
		    }]
		}); 

		var treestore = new Ext.data.TreeStore({
                model: deptModel,
                proxy: {
	                type: 'direct',
	                api: {
	                	   read : 'bor130ukrvService.selectList'
	                	
	                }
	            },
                autoLoad: true,
                folderSort: true
            });

		var grid = Ext.create('Unilite.com.grid.UniTreeGridPanel', {
			flex:1,
	        store: treestore,   
	        useArrows: true,
		    rootVisible: false,
		    multiSelect: false,
		    //singleExpand: true,
			plugins: [ {ptype: 'cellediting', clicksToEdit: 1} ],
	        columns: [{
		                xtype: 'treecolumn', //this is so we know which column will show the tree
		                text: 'Task',
		                flex: 1,
		                sortable: true,
		                dataIndex: 'treeName'
		            },{
		                text: '부서',
		                sortable: true,
		                dataIndex: 'treeCode',
		                width: 80,
		                editor: {
		                    allowBlank: false
		                }
		            },{
		                flex: 1,
		                sortable: true,
		                dataIndex: 'treeName',
		                editor: {
		                    allowBlank: false
		                }
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
		                sortable: true,
		                editor: {
		                    allowBlank: false
		                }
		            }]
		}); // grid
		


			
		Ext.create('Ext.Viewport',{		
			    defaults: {padding:5},
				
			    items:[grid],
			    layout : {	type: 'vbox', pack: 'start', align: 'stretch' }
			}
	    );
	    

	});
</script>