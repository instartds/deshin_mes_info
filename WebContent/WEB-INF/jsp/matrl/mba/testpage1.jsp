<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="testpage1">
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	
	Ext.define("Docs.view.search.Container", {
	extend: "Ext.container.Container",
	alias: "widget.searchcontainer",
	initComponent: function() {
    	var searchStore  = Ext.create('Ext.data.Store',{
            fields: [ 
	            {name:'PGM_NAME', type:'string'}
            ],
            storeId: 'SearchMenuStore',
            autoLoad: false,
            pageSize: 15,
            proxy: {
                type: 'direct',
                api: {
                    read : 'testPage1Service.searchMenu'
                },
	            reader: {
	                type: 'json',
			<c:choose>
	        	<c:when test="${ext_version == '4.2.2'}">
	        		root: 'records'	//4.2.2
	        	</c:when>		
	        	<c:otherwise>
	        		rootProperty: 'records'	//5.1.0
	        	</c:otherwise>		
	        </c:choose>		                
	            }
            }
        });
//        this.cls = "search";
		this.items = [{
			fieldLabel:'테스트',
	        xtype: "combobox",
//	        <c:if test="${ext_version == '4.2.2'}">
//        		plugins: ['uniClearbutton'],	//4.2.2. 5.x은 clear trigger 가 plugin 이 아님.제거.
//        	</c:if>
  	        store: searchStore,
	        queryMode: 'remote',
//	        pageSize: true, // This just causes a paging toolbar to show
	        displayField: 'PGM_NAME',
	        minChars: 1,
	        queryParam: 'searchStr',
	        hideTrigger: true,
	        selectOnFocus: false,
	        width: 500
		}];      
    
		this.callParent()
	}
});
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

Ext.define('ABCModel', {
	    extend: 'Ext.data.Model',
	    fields: [ 'A',// 프로젝트 명
	              'AA'		// 프로젝트 No
	             ]
	});
    var testStore = Ext.create("Ext.data.DirectStore", {
			model : "ABCModel",
			//autoLoad : true,
			proxy : {
				type : "direct",
				api : {
					read : 'testPage1Service.A'
				},
				reader : {
					type : 'json',
					rootProperty : 'data',
					totalProperty : 'totalCount'
				}
			}
		});
    
	var panelResult = Unilite.createSearchForm('resultForm',{	
		title: '테스트 페이지',
        defaultType: 'uniSearchSubPanel',
        width:1000,
        
		items: [{	
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items :[{
				fieldLabel: '테스트000',
				name: 'ABC', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('whList'),
				multiSelect: true
				
				/*displayField : 'A',
				valueField : 'AA'*/
//				renderTo: Ext.getBody()
			}, {
            	fieldLabel: '기초년월',
            	name: 'COUNT_DATE',
				holdable: 'hold',
            	xtype: 'uniMonthfield', //xtype: 'uniDatefield', 
            	//colspan: '2',
            	allowBlank: false
            },
		    	
		    		
		    			
		    { 
                    xtype: "searchcontainer"
                },
		    {
		    	fieldLabel:'테스트1',
		    	xtype:'uniTextfield',
		    	name: 'TEST1'
		    	
		    },{
		    	fieldLabel:'테스트2',
		    	xtype:'uniTextfield',
		    	name: 'TEST2'
		    	
		    },{
	    		xtype: 'uniRadiogroup',
	    		name: 'RDO6',
	    		items: [{
	    			boxLabel: '예',
	    			width: 150,
	    			name: 'RDO6',
	    			inputValue: '1'
	    		}, {
	    			boxLabel: '아니오',
	    			width: 150,
	    			name: 'RDO6',
	    			inputValue: '2',
	    			checked: true
	    			
	    		}]
	        },{
					xtype: 'fieldset',
					title: '테스트필드셋',
					layout: {type: 'uniTable', columns: 1},
					items:[{
						border: false,
						name: '',
						html: "<font color = 'blue' >테스트.</font>",
						width: 350
					}, {
			    		xtype: 'uniCheckboxgroup',		            		
			    		fieldLabel: '테스트',
			    		items: [{
			    			boxLabel: '테스트1',
			    			width: 100,
			    			name: 'A1',
			    			inputValue: 'Y'
			    		}, {
			    			boxLabel: '테스트2',
			    			width: 100,
			    			name: 'A2',
			    			inputValue: 'Y'
			    		}, {
			    			boxLabel: '테스트3',
			    			width: 100,
			    			name: 'A3',
			    			inputValue: 'Y'
			    		}]
			        }]		
				}]
		    	
		}],api: {
			load: 'testPage1Service.selectForm'				
		}
	});   
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
			panelResult
		]
		}],
		id  : 'testpage1App',
		
		fnInitBinding: function() {
			
//			UniAppManager.setToolbarButtons('query',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown: function()	{
			
			var param= panelResult.getValues();
				panelResult.getForm().load({
					
					params: param
					/*success: function()	{
						alert('qqq');
//						masterForm.uniOpt.inLoading=false;
					},
					failure: function(form, action) {
						alert('qq2q');
//                        masterForm.uniOpt.inLoading=false;
                    }*/
				})
		}

		
	});
		
};


</script>
