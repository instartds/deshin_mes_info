<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
    request.setAttribute("ext_url", "/extjs/ext-all-dev.js");
	
    request.setAttribute("css_url", "/extjs/resources/ext-theme-classic-omega/ext-overrides.css"); // 4.2.2    
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Edit Grid Sample</title>

	<link rel="stylesheet" type="text/css" href='<c:url value="${css_url}" />' />
	<script type="text/javascript" charset="UTF-8" src='<c:url value="${ext_url }" />'></script>

    <script type="text/javascript">
    	var CPATH ='<%=request.getContextPath()%>';
        Ext.Loader.setPath('Unilite', CPATH +'/app/Unilite');
    </script>
    
    <script type="text/javascript">
        Ext.define('Writer.Grid', {
		    extend: 'Ext.grid.Panel',
		    alias: 'widget.writergrid',
			viewConfig : {
				shrinkWrap: 1 //3, 			//default: 2
				//enableTextSelection: true, 	//default: false 
				//loadMask: true,				//default: true
				//trackOver: true,				//default: false 
				//stripeRows: true				//default: true 겹줄표시		
			},
		    requires: [
		        'Ext.grid.plugin.CellEditing',
		        'Ext.form.field.Text',
		        'Ext.toolbar.TextItem'
		    ],
		
		    initComponent: function(){
		
		        this.editing = Ext.create('Ext.grid.plugin.CellEditing');
		
		        Ext.apply(this, {
		            frame: true,		            
		            plugins: [
		            	this.editing/*, 
		            	Ext.create('Ext.grid.plugin.BufferedRenderer')*/
		            ],
		            //selType: 'cellmodel',
		            dockedItems: [{
		                xtype: 'toolbar',
		                items: [{
		                    text: 'Add',
		                    scope: this,
		                    handler: this.onAddClick
		                }, {
		                    text: 'Delete',
		                    disabled: true,
		                    itemId: 'delete',
		                    scope: this,
		                    handler: this.onDeleteClick
		                }]
		            }],
		            columns: [/*{
		                text: 'ID',
		                width: 40,
		                sortable: true,
		                resizable: false,
		                draggable: false,
		                hideable: false,
		                menuDisabled: true,
		                locked: true,
		                dataIndex: 'id',
		                field: {
		                    type: 'textfield'
		                }
		            }, */{
		                header: 'Email',
		                flex: 1,
		                sortable: true,
		                hidden: true,
		                dataIndex: 'email',
		                field: {
		                    type: 'textfield'
		                }
		            }, {
		                header: 'First',
		                width: 100,
		                sortable: true,
		                locked: true,
		                dataIndex: 'first',
		                field: {
		                    type: 'textfield'
		                }
		            }, {
		                header: 'Last',
		                width: 100,
		                sortable: true,
		                dataIndex: 'last',
		                field: {
		                    type: 'textfield'
		                }
		            }]
		        });
		        this.callParent();
		        this.getSelectionModel().on('selectionchange', this.onSelectChange, this);
		    },
		    
		    onSelectChange: function(selModel, selections){
		        this.down('#delete').setDisabled(selections.length === 0);
		    },
		
		    onDeleteClick: function(){
		        var selection = this.getView().getSelectionModel().getSelection()[0];
		        if (selection) {
		            this.store.remove(selection);
		        }
		    },
		
		    onAddClick: function(){
		        var rec = new Writer.Person({
		            first: '',
		            last: '',
		            email: ''
		        }), edit = this.editing;
		
		        edit.cancelEdit();
		        this.store.insert(0, rec);
//		        edit.startEditByPosition({
//		            row: 0,
//		            column: 1
//		        });
		    }
		});
		
		Ext.define('Writer.Person', {
		    extend: 'Ext.data.Model',
		    fields: [{
		        name: 'id',
		        type: 'int',
		        useNull: true
		    }, 'email', 'first', 'last'],
		    validations: [{
		        type: 'length',
		        field: 'email',
		        min: 1
		    }, {
		        type: 'length',
		        field: 'first',
		        min: 1
		    }, {
		        type: 'length',
		        field: 'last',
		        min: 1
		    }]
		});
		
		Ext.require([
		    'Ext.data.*',
		    'Ext.tip.QuickTipManager',
		    'Ext.window.MessageBox'
		]);

        Ext.onReady(function(){
        	Ext.tip.QuickTipManager.init();
        	
        	var store1 = Ext.create('Ext.data.JsonStore', {
	            model: 'Writer.Person',
	            data: [
					{id: 1, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 2, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 3, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 4, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 5, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 6, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 7, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 8, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 9, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 10, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 11, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 12, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 13, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 14, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 15, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 16, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 17, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 18, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 19, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 20, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 21, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 22, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 23, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 24, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 25, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 26, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 27, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 28, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 29, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 30, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 31, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 32, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 33, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 34, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 35, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 36, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 37, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 38, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 39, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 40, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 41, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 42, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 43, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 44, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 45, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 46, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 47, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 48, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 49, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 50, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 51, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 52, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 53, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 54, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 55, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 56, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 57, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 58, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 59, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 60, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 61, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 62, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 63, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 64, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 65, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 66, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 67, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 68, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 69, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 70, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 71, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 72, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 73, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 74, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 75, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 76, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 77, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 78, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 79, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 80, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 81, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 82, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 83, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 84, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 85, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 86, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 87, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 88, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 89, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 90, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 11, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 12, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 13, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 14, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 15, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 16, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 17, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 18, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 19, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 20, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 1, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 2, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 3, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 4, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 5, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 6, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 7, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 8, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 9, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 10, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 11, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 12, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 13, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 14, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 15, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 16, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 17, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 18, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 19, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 20, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 21, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 22, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 23, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 24, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 25, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 26, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 27, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 28, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 29, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 30, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 31, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 32, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 33, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 34, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 35, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 36, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 37, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 38, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 39, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 40, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 41, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 42, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 43, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 44, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 45, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 46, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 47, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 48, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 49, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 50, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 51, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 52, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 53, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 54, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 55, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 56, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 57, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 58, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 59, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 60, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 61, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 62, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 63, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 64, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 65, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 66, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 67, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 68, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 69, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 70, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 71, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 72, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 73, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 74, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 75, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 76, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 77, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 78, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 79, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 80, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 81, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 82, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 83, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 84, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 85, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 86, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 87, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 88, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 89, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 90, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 11, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 12, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 13, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 14, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 15, email:'Betty@flintstone.com', first:'Betty', last:'Flintstone' },
					{id: 16, email:'fred@flintstone.com', first:'Fred', last:'Flintstone' },
					{id: 17, email:'Wilma@flintstone.com', first:'Wilma', last:'Flintstone' },
					{id: 18, email:'Pebbles@flintstone.com', first:'Pebbles', last:'Flintstone' },
					{id: 19, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' },
					{id: 20, email:'Barney@flintstone.com', first:'Barney', last:'Flintstone' }
	            ]
	        });        	
		
		    var main = Ext.create('Ext.container.Container', {
		        padding: '0 0 0 20',
		        width: 500,
		        height: Ext.themeName === 'neptune' ? 500 : 450,
		        renderTo: document.body,
		        layout: {
		            type: 'vbox',
		            align: 'stretch'
		        },
		        items: [{
		            itemId: 'grid',
		            xtype: 'writergrid',
		            title: 'User List',
		            flex: 1,
		            store: store1/*,
		            listeners: {
		                selectionchange: function(selModel, selected) {
		                    main.child('#form').setActiveRecord(selected[0] || null);
		                }
		            }*/
		        }]
		    });
        });
    </script>
    <!-- </x-compile> -->
</head>
<body>
</body>
</html>
