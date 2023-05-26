<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="cmd140skrv"  >
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	/**
	 * Model 정의
	 * 
	 * @type
	 */
	
	Unilite.defineModel('Cmd140skrvModel', {
	    fields: [{name:'CUSTOM_NAME'	,text:'거래처',			type:'string' },
             	 {name:'CUSTOM_CODE'	,text:'거래처코드',		type:'string' },
	             {name:'DOC_NO'			,text:'문서번호',		type:'string' },
	             {name:'PROJECT_NO'		,text:'영업기회 번호',	type:'string' },
	             {name:'PROJECT_NAME'	,text:'영업기회명',		type:'string' },	             
	             {name:'MAKE_DATE'		,text:'등록일',			type:'uniDate' },
	             {name:'ORG_FILE_NAME'	,text:'파일명',			type:'string' },
	             {name:'MIME_TYPE'		,text:'형식',			type:'string' },
	             {name:'FILE_SIZE'		,text:'용량(Mbyte)',	type:'uniER'},
	             {name:'MAKE_EMP'		,text:'등록자 사번',	type:'string' },
	             {name:'EMP_NAME'		,text:'등록자 명',		type:'string'},
	             {name:'SUMMARY_STR'	,text:'내용',			type:'string' }	             

	    ]
	});
						
	var directMasterStore = Unilite.createStore('cmd140skrvMasterStore', {
			model: 'Cmd140skrvModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'cmd140skrvService.selectList'
                }
            }
            ,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	
            
	/**
	 * 검색조건 (Search Panel)
	 * 
	 * @type
	 */     
  	var panelSearch = Unilite.createSearchForm('searchForm', {
        
        items: [{
            xtype:'container',
            flex: 1,
            layout : {type : 'uniTable', columns : 2},
            defaultType: 'uniTextfield',
            items :[  Unilite.popup('CUST',{textFieldWidth:170})
            		,{ fieldLabel: '등록일자'
		               ,xtype: 'fieldcontainer'
		               ,layout: 'hbox'
		               ,width: 350
		               ,defaults: {flex: 1, hideLabel: true}
		               ,items: [
		                     {fieldLabel: 'Start'	,name:'MAKE_DATE_FR' , suffixTpl:'&nbsp;~&nbsp;' 	,xtype:'uniDatefield', margin: '0 5 0 0', value :UniDate.get('startOfYear')}
		                    
		                    ,{fieldLabel: 'End'		,name:'MAKE_DATE_TO'	,xtype:'uniDatefield', value :UniDate.get('endOfMonth')}
		                ]		               
	            	 }
	            	,{ fieldLabel: '내용',		name: 'SUMMARY_STR' ,width:315}
            	    ,{ fieldLabel: '파일명',	name: 'ORG_FILE_NAME',width:350}
	       			/* ,{ fieldLabel: '등록자', name: 'EMP_NAME'} */
				    
					// ,{ fieldLabel: '영업기회명', name: 'PROJECT_NAME'}
		            ,Unilite.popup('CLIENT_PROJECT',{fieldLabel:'영업기회명',textFieldWidth:170, validateBlank: false}) 
		            , Unilite.popup('Employee',{fieldLabel:'등록자'}) 
				    				
        			]
        }]
    }); // createSearchForm

       /**
		 * Master Grid 정의(Grid Panel)
		 * 
		 * @type
		 */ 

    var masterGrid = Unilite.createGrid('cmd140skrvGrid', {
        store: directMasterStore, 
        columns:  [        	    	
					{ dataIndex: 'CUSTOM_NAME'		,width: 150}    	
					,{ dataIndex: 'PROJECT_NAME'	,width: 200}   	
					,{ dataIndex: 'MAKE_DATE'		,width: 90}    			
					,{ dataIndex: 'ORG_FILE_NAME'	,width: 200}    	
					,{ dataIndex: 'MIME_TYPE'		,width: 80}    	
					,{ dataIndex: 'FILE_SIZE'		,width: 80 }    
					,{header: '작업', xtype:'actioncolumn', align : 'center', width : 50,
					items: [{
		                icon: CPATH+'/resources/css/icons/upload_save.png',
		                tooltip: '다운로드',
		                handler: function(grid, rowIndex, colIndex) {
		                	var id = grid.store.getAt(rowIndex).get('id');
		                    
		                }},
		                {
		                icon: CPATH+'/resources/css/icons/upload_open.png',
		                tooltip: '파일열기',
		                handler: function(grid, rowIndex, colIndex) {
		                	var id = grid.store.getAt(rowIndex).get('id');
		                    
		                }
		            }]}
					,{ dataIndex: 'EMP_NAME'		,width: 80}    		
					,{ dataIndex: 'SUMMARY_STR'		,flex:1}    	

          ] ,
          listeners: {
	          onGridDblClick:function(grid, record, cellIndex, colName) {
	          			switch(colName)	{
						case 'ORG_FILE_NAME' :
								;
								break;					
						default:
								break;
	          			}
	          }
          } // listeners
         
    });
     

    Unilite.Main( {
			 items 	: [ panelSearch, masterGrid]
			,fnInitBinding:function()	{}
			,onQueryButtonDown:function () {
					directMasterStore.loadStoreRecords();					
				},
			onResetButtonDown:function() {
				Ext.getCmp('searchForm').reset();
				masterGrid.reset();
			}
		});

};
</script>

