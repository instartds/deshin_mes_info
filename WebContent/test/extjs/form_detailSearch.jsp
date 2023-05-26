<%@page language="java" contentType="text/html; charset=utf-8"%>
<script type="text/javascript" >
Ext.require([
    '*',
    'Ext.ux.grid.FiltersFeature',
    'Ext.ux.DataTip'
]);


	
Ext.onReady(function() {
	Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
	
	Ext.define("uniliteCustomModel", {
	    extend: 'Ext.data.Model',
        fields: [
            'customCode','customName'
        ]
    });
    
     var customStore = Ext.create("Ext.data.DirectStore",{
            model : "uniliteCustomModel",
            //autoLoad : true,
            proxy : {
                        type : "direct",
                        api : {
                        	read: 'cmb200skrvService.selectCustomList'
                        },
		                reader: {
		                    type: 'json',
		                    root: 'data',
		                    totalProperty: 'totalCount'
		                }                        
                    }
            });   
            

    ///////////////////////////////
	
	Ext.define('Cmb200skrvModel', {
	    extend: 'Ext.data.Model',
	    fields: [ 'customName', 'projectName', 'projectType',
	              'importanceStatus','saleEmp' , 'frghtIndctr', 'monthQuantity',
	              'planTarget','currentDd','summaryStr','planTarget']
	});
	
	

	//var form = Ext.getCmp('searchForm');	console.log(form.getValues());
						
	var directStore = new Ext.data.DirectStore({
			model: 'Cmb200skrvModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'cmb200skrvService.selectDataListR'
                }
            }
	});
	
	var filters = {
        ftype: 'filters',
        encode: false,
        local: true, 

        filters: [{
            type: 'boolean',
            dataIndex: 'visible'
        }]
    };	
	
    // create the Grid
    var masterGrid = Ext.create('Ext.grid.Panel', {
    	selType: 'cellmodel',
    	forceFit: true,
    	flex:1,
    	features: [filters],
        store: directStore,
        margin: '5 5 5 5',
        headerCfg:{
        	tag:'center'
        },
        columnLines: true,
        columns:  [        
                { dataIndex: 'customName',  width: 130,  text: '거래처',  locked: true, style: 'text-align:center',
                	filter: {type: 'uniList'}
                },
				{ dataIndex : 'projectName', width: 200,  text: '영업기회명', locked: true, style: 'text-align:center',},
				{ dataIndex : 'projectType', width: 110,  text: '구분',style: 'text-align:center', 
                	filter: {type: 'uniList'}
                },
				{ dataIndex : 'importanceStatus', width: 50,  text: '중요도', style: 'text-align:center',
                	filter: {type: 'uniList'}
                },
				{ dataIndex : 'saleEmp', width: 50,  text: '영업담당', style: 'text-align:center',
                	filter: {type: 'uniList'}
                },
				{ dataIndex : 'frghtIndctr', width: 100,  text: '완료목표일',style: 'text-align:center'},				
				{ dataIndex : 'monthQuantity', width: 80,  text: '예상규모',style: 'text-align:center',
					align: 'right',
					xtype: 'numbercolumn', format:'0,000'
				},
				{ dataIndex : 'planTarget', width: 80,  text: '상태',style: 'text-align:center'},
				{ dataIndex : 'currentDd', width: 80,  text: '현사용제품',style: 'text-align:center'},
				{ dataIndex : "summaryStr", width: 240,  text: '현황',style: 'text-align:center' },
				{ dataIndex : 'planTarget', width: 240,  text: '계획',style: 'text-align:center', flex: 1 }                 
          ] 
    });
    
    
     var fsf = {
        xtype: 'form',
        id: 'searchForm',
        collapsible: false,
        bodyPadding: '5 5 0 5',
        border: 0,
        width: '100%',
        fieldDefaults: {
            msgTarget: 'side',
            labelAlign: 'right',
            labelWidth: 100,
		    labelSeparator : ""
        },
        defaults: {
            anchor: '100%'
        },

        items: [{
            xtype:'container',
            layout: 'hbox',
            anchor: '100%',
            items :[{
            	xtype: 'container',
            	defaultType: 'textfield',
            	flex: 1,
            	layout : 'anchor',
            	items : [{
	                fieldLabel: '거래처',
	                name: 'CUSTOM_CODE',
	                xtype: 'combo',
		            store: customStore,
		            displayField: 'customName',
		            typeAhead: false,
		            hideLabel: false,
		            hideTrigger:true,
		            anchor: '100%',
		            queryDelay : 1,
					//selectOnFocus: true,
					hiddenName: 'customCode',
                    valueField: 'customCode',
		            listConfig: {
		                loadingText: 'Searching...',
		                emptyText: 'No matching posts found.',
		
		                // Custom rendering template for each item
		                getInnerTpl: function() {
		                    return '{customCode} : {customName}';
		                }
		            },
		            pageSize: 10,
		            minChars : 1
	            },
	            {
	                fieldLabel: '영업기회 유형',
	                name: 'srchProjectOptGroup',
	                xtype: 'radiogroup',
	                columns: [50,50],
	                items: [
		                {boxLabel: '내부', name: 'srchProjectOpt', inputValue: '1' },
		                {boxLabel: '외부', name: 'srchProjectOpt', inputValue: '2', checked: true}
		            ]
	            }]
            },
            {
            	xtype: 'container',
            	flex: 1,
            	layout : 'anchor',
            	defaultType: 'textfield',
            	items : [{
	                fieldLabel: '고객명',
	                name: 'last'
	            },
	            {
	                fieldLabel: '중요도',
	                name: 'srchImportanceGroup',
	                xtype: 'checkboxgroup',
	                items: [
		                {boxLabel: '상', name: 'srchImportance[]', inputValue: 'A1', checked: true},
		                {boxLabel: '중', name: 'srchImportance[]', inputValue: 'B1', checked: true},
		                {boxLabel: '하', name: 'srchImportance[]', inputValue: 'C1', checked: true}
		            ]
	            }]
            },
            {
            	xtype: 'container',
            	flex: 1,
            	layout : 'anchor',
            	defaultType: 'textfield',
            	items : [
            		{
		                xtype: 'fieldcontainer',
		                fieldLabel: '시작일(계획일)',
		                combineErrors: true,
		                msgTarget : 'side',
		                layout: 'hbox',
		                defaults: {
		                    flex: 1,
		                    hideLabel: true
		                },
		                items: [
		                    {
		                        xtype     : 'datefield',
		                        name      : 'txtEndFrDate',
		                        fieldLabel: 'Start',
		                        margin: '0 5 0 0'
		                    },
		                    {
		                        xtype     : 'datefield',
		                        name      : 'txtEndToDate',
		                        fieldLabel: 'End'
		                    }
		                ]		               
	            },
	            {
		                xtype: 'fieldcontainer',
		                fieldLabel: '목표일(실행일)',
		                combineErrors: true,
		                msgTarget : 'side',
		                layout: 'hbox',
		                defaults: {
		                    flex: 1,
		                    hideLabel: true
		                },
		                items: [
		                    {
		                        xtype     : 'datefield',
		                        name      : 'txtStartFrDate',
		                        fieldLabel: 'Start',
		                        margin: '0 5 0 0',
		                        allowBlank: false
		                    },
		                    {
		                        xtype     : 'datefield',
		                        name      : 'txtStartToDate',
		                        fieldLabel: 'End',
		                        allowBlank: false
		                    }
		                ]		               
	            }]
            }]
        },{
            xtype:'fieldset',
            title: 'Detail',
            collapsible: true,
            collapsed:true,
            defaultType: 'textfield',
            layout: 'anchor',
            defaults: {
                anchor: '100%'
            },
            items :[{
                fieldLabel: 'Sample',
                name: 'home',
                value: '(888) 555-1212'
            }]
        }]
    };    
    
    var panelSearch =  {
        xtype:'panel',
    	id:'panelSearch',
		contentEl : 'elSearch',
		flex: 0,
		border:0,
		margin:'0 0 0 0 ',
		dockedItems : [ {
				dock : 'top',
				xtype : 'toolbar',
				items : [ {
					xtype : 'button',text : '조회',tooltip : '조회',iconCls : 'icon-query',
					handler: function() {
                		var param= Ext.getCmp('searchForm').getValues();
                		console.log( param );
						masterGrid.getStore().load({params: param});
					}
				}, {
					xtype : 'button',text : '신규',tooltip : '초기화', iconCls: 'icon-reset',
					handler : function() {
						
					}
				}, {
					xtype : 'button',text : '추가',tooltip : '추가', iconCls: 'icon-new', disabled: true
				}, {
					xtype : 'button',text : '저장',tooltip : '저장', iconCls: 'icon-save', disabled: true
				}, {
					xtype : 'button',text : '이전',tooltip : '이전 레코드', iconCls: 'icon-movePrev',disabled: true
				}, {
					xtype : 'button',text : '다음',tooltip : '다음 레코드', iconCls: 'icon-moveNext', disabled: true
				}   ]
			} ],
		items : [ fsf ]
	};
	
	
    Ext.create('Ext.Viewport', {
		layout : {
	 		type: 'vbox',
		    pack: 'start',
		    align: 'stretch'
		},
		
		items : [panelSearch, 	masterGrid],
		renderTo : Ext.getBody()
	});
    
    
    
});


</script>
<!-- Search Area  -->

<div id="elSearch" class="x-hide-display">
	<div id="elSearchCondition"></div>
</div>

<div id='elGrid' class="x-hide-display">
</div>

<!-- //List Area -->
