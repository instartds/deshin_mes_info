<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cmb200skrpv"  />

<script type="text/javascript" >
function appMain()  {

	var panelSearch = {
        xtype: 'uniSearchForm',
        id: 'searchForm',
        layout : {type : 'table', columns : 2, tableAttrs: {
            style: {
                width: '100%'
            }
        }},
        width:'100%',
        items: [ { fieldLabel: '거래처', 	name:'CUSTOM_CODE',	hidden:true}  			 
		        
		]
    };  
    
	  var cmb200skrpvDetail = Ext.create('Unilite.com.form.UniDetailFormSimple', {
	    id : 'cmb200skrpvDetail'
	    ,layout: {type:'uniTable' ,  columns : 2 }  
	    ,autoScroll:true
		,flex:1
	    ,items: [ 
	    		{fieldLabel: '매출액'	,name: 'SALE_AMT', readOnly:true}      
	            ,{hideLabel :true		,name: 'SALE_YYYY', suffixTpl:'&nbsp;년도', readOnly:true}
	            ,{fieldLabel: '종업원수',name: 'PERSON_CNT', readOnly:true}      
	            ,{hideLabel :true		,name: 'BASE_YYYY', suffixTpl:'&nbsp;년도', readOnly:true}
	            ,{fieldLabel: '대표제품',name: 'MAJOR_ITEM', colspan:'2', readOnly:true}      
	            ,{fieldLabel: '제품종류수',name: 'ITEM_CNT', readOnly:true}
	            ]
	    
        	,api: {
				load: 'cmPopupService.customInfoPop'			
			}
	});
	
	   
	
	
  	Unilite.PopupMain({
		items : [panelSearch, cmb200skrpvDetail],
		autoScroll:true,
		id  : 'cmb200skrpvApp',
		fnInitBinding : function() {
			var param = window.dialogArguments;
			var frm= Ext.getCmp('searchForm').getForm();
			frm.setValue('CUSTOM_CODE', param['CUSTOM_CODE']);
			this._dataLoad();
		},
		 onQueryButtonDown : function()	{
			this._dataLoad();
		},
		_dataLoad : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			cmb200skrpvDetail.getForm().load({
				params : param
			});
		}
	});

};

</script>