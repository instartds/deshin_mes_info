<%@page language="java" contentType="text/html; charset=utf-8"%>
<script type="text/javascript" src='<c:url value="/api-debug.do" />'></script>
<script type="text/javascript">


//Ext.ns("Ext.app"); 
Ext.app.REMOTING_APIX = {
		url:"${CPATH}/cm/cmb200skrvR.do",
		type:"remoting",
		actions:{
				"QueryDatabase":[{"name":"getResults","len":1}]
		},
		total:2200};
</script>
<script type="text/javascript">
	
Ext.onReady(function() {
	Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
	
	Ext.define('Cmb200skrv', {
	    extend: 'Ext.data.Model',
	    fields: [ 'customName', 'projectName', 'projectType',
	              'importanceStatus','saleEmp' , 'frghtIndctr', 'monthQuantity',
	              'planTarget','currentDd','summaryStr','planTarget']
	});

	
	var directStore = new Ext.data.DirectStore({
			model: 'Cmb200skrv',
            autoLoad: true,
            proxy: {
                type: 'direct',
                directFn: cmb200skrvService.selectDataListR
            }
	});
	var filters = {
        ftype: 'filters',
        // encode and local configuration options defined previously for easier reuse
        encode: false, // json encode the filter query
        local: true,   // defaults to false (remote filtering)

        // Filters are most naturally placed in the column definition, but can also be
        // added here.
        filters: [{
            type: 'boolean',
            dataIndex: 'visible'
        }]
    };	
    // create the Grid
    var masterGrid = Ext.create('Ext.grid.Panel', {
    	selType: 'cellmodel',
    	features: [filters],
        store: directStore,
        headerCfg:{
        	tag:'center'
        },
        columns: [
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
				{ dataIndex : 'frghtIndctr', width: 100,  text: '완료목표일',style: 'text-align:center',},				
				{ dataIndex : 'monthQuantity', width: 80,  text: '예상규모',style: 'text-align:center',
					align: 'right',
					xtype: 'numbercolumn', format:'0,000'
				},
				{ dataIndex : 'planTarget', width: 80,  text: '상태',style: 'text-align:center',},
				{ dataIndex : 'currentDd', width: 80,  text: '제품',style: 'text-align:center',},
				{ dataIndex : "summaryStr", width: 240,  text: '현황',style: 'text-align:center',},
				{ dataIndex : 'planTarget', width: 240,  text: '계획',style: 'text-align:center',},                 
          ]    
    });
    
    
 	var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
     var fsf = {
        xtype: 'form',
        id: 'fieldSetForm',
        collapsible: false,
        width: '100%',
        fieldDefaults: {
            msgTarget: 'side',
            labelWidth: 75
        },
        defaults: {
            anchor: '100%'
        },

        items: [{
            xtype:'container',
            title: 'User Information',
            defaultType: 'textfield',
            collapsible: false,
            layout: 'anchor',
            defaults: {
                anchor: '100%'
            },
            items :[{
                fieldLabel: '거래처',
                afterLabelTextTpl: required,
                name: 'first',
                allowBlank:false
            },{
                fieldLabel: '고객명',
                afterLabelTextTpl: required,
                name: 'last'
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
                fieldLabel: 'Home',
                name: 'home',
                value: '(888) 555-1212'
            },{
                fieldLabel: 'Business',
                name: 'business'
            },{
                fieldLabel: 'Mobile',
                name: 'mobile'
            }]
        }]
    };    
    
    var panelSearch =  {
        xtype:'panel',
    	id:'panelSearch',
		contentEl : 'elSearch',
		flex: 0,
		dockedItems : [ {
				dock : 'top',
				xtype : 'toolbar',
				items : [ {
					xtype : 'button',text : '조회',tooltip : '조회',iconCls : 'icon-query',
					handler: function() {
						masterGrid.getStore().load();
					}
				}, {
					xtype : 'button',text : '신규',tooltip : '초기화', iconCls: 'icon-reset',
				}, {
					xtype : 'button',text : '추가',tooltip : '추가', iconCls: 'icon-new',
				}, {
					xtype : 'button',text : '저장',tooltip : '저장', iconCls: 'icon-save',
				}, {
					xtype : 'button',text : '이전',tooltip : '이전 레코드', iconCls: 'icon-movePrev',
				}, {
					xtype : 'button',text : '다음',tooltip : '다음 레코드', iconCls: 'icon-moveNext',
				}   ]
			} ],
		items : [ fsf
		         ]
	};
	
	
    Ext.create('Ext.Viewport', {
		layout : {
	 		type: 'vbox',
		    pack: 'start',
		    align: 'stretch'
		},
		
		items : [ panelSearch, masterGrid],
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
