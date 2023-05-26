<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr100ukrv"  >
</t:appConfig>
<script type="text/javascript" >
//var detailWin;


function appMain(mainApp) {
	
	var panelSearch = Ext.create('Ext.form.Panel', {    
			itemId: 'search_panel1',
			layout: {type: 'hbox', align: 'stretch'},
			style:{
				'line-height':'30px'
			},
			defaults:{
				labelWidth:80
			},
            items: [ {
    			xtype: 'textfield',
	            name: 'ITEM_CODE',  		
    			label: '품목코드',
				flex:0.5
    		},{ 
    			xtype: 'textfield',
            	name: 'ITEM_NAME',  		
            	label: '품목명',
				flex:0.5
            },{ 
    			xtype: 'button',
    			
            	text: '조회',
            	handler:function()	{
            		directMasterStore.loadStoreRecords()
            	}
            }]
	});
	
	/**
	 * Master Model
	 */				
	 Ext.define('bpr103ukrvModel', {
		extend:'Ext.data.Model',	
		fields: [	 //BPR100T필수
					{ name: 'ITEM_CODE',  		text: '품목코드', 		type : 'string' }      
			  		,{ name: 'ITEM_NAME', 		text: '품목명', 		type : 'string'}        
			  		
			  		,{ name: 'SPEC',  			text: '규격', 			type : 'string'}
				    ,{ name: 'ITEM_LEVEL1', 	text: '대분류', 		type : 'string'}        					       
				    ,{ name: 'ITEM_LEVEL2', 	text: '중분류', 		type : 'string'}        
				    ,{ name: 'ITEM_LEVEL3', 	text: '소분류', 		type : 'string'}
			  		,{ name: 'SALE_UNIT',  		text: '판매단위', 		type : 'string'}      
			  		]
	});
	
	/**
	 * Master Store
	 */
	var directMasterStore = Ext.create('Ext.data.Store',{
		
			storeId:'bpr103ukrvMasterStore',
			proxy: {
	            type: 'direct',
	            api: {
	                read: 'bpr100ukrvService.selectDetailList2'
	            }
	        },
			model: 'bpr103ukrvModel',
           	autoLoad: false
        	,loadStoreRecords : function()	{
				var param= panelSearch.getValues();
				this.load({
						params : param,
						callback : function(records, operation, success) {
							if(success)	{
	    						
							}
						}
					}
				);
				
			}
	});
	
	var itemViewConf = {
		
        title: '품목상세정보',
        layout: 'vbox',
        height:'100%',
        width:'100%',
        style:"background-color:#ffffff;",
        tpl: [
            '<div class="top">',
               // '<div style="width:100%; background-color:#eeeeee;line-height:30px; font-weight:bold; text-align:center;">품목상세정보</div><br/>'+
            	'<div class="name" style="width:300px"> {ITEM_NAME} ({ITEM_CODE})<br/></div><br/>' +
                '<div >규격 : {SPEC}<br/>' +
                '재고단위 : {STOCK_UNIT}<br/>' +
                '대분류 : {ITEM_LEVEL1}<br/>' +
                '중분류 : {ITEM_LEVEL2}<br/>' +
                '소분류 : {ITEM_LEVEL3}<br/>' +
                '대표모델코드 : {ITEM_GROUP}<br/>' +
                '대표모델명 : {ITEM_GROUP_NAME}<br/>' +
                '색상 : {ITEM_COLOR}<br/>' +
                '사이즈 : {ITEM_SIZE}<br/>' +
                '단위중량 : {UNIT_WGT}<br/>' +
                '중량단위 : {WGT_UNIT}<br/>' +
                '단위부피 : {UNIT_VOL}<br/>' +
                '부피단위 : {VOL_UNIT}<br/>' +
                '비중 : {REIM}<br/>' +
                '도면번호 : {SPEC_NUM}<br/>' +
                '판매단위 : {SALE_UNIT}<br/>' +
                '판매입수 : {TRNS_RATE}<br/>' +
                '세구분 : {TAX_TYPE}<br/>' +
                '판매단가 : {SALE_BASIS_P}<br/>' +
                '국내외 : {DOM_FORIGN}<br/>' +
                '재고관리대상 : {STOCK_CARE_YN}<br/>' +
                '집계품목코드 : {TOTAL_ITEM}<br/>' +
                '집계품목명 : {TOTAL_ITEM_NAME}<br/>' +
                '집계환산계수 : {TOTAL_TRAN_RATE}<br/>' +
                '바코드 : {BARCODE}<br/>' +
                'HS번호 : {HS_NO}<br/>' +
                'HS명 : {HS_NAME}<br/>' +
                'HS단위 : {HS_UNIT}<br/>' +
                '제조메이커 : {ITEM_MAKER}<br/>' +
                '메이커 Part No : {ITEM_MAKER_PN}<br/>' +
                '사진유무 : {PIC_FLAG}<br/>' +
                '사용시작일 : {START_DATE}<br/>' +
                '사용중단일 : {STOP_DATE}<br/>' +
                '사용유무 : {USE_YN}<br/>' +
                '과출고허용률 : {EXCESS_RATE}<br/>' +
                '유효일자 : {USE_BY_DATE}<br/>' +
                '유효일자관리여부 : {CIR_PERIOD_YN}<br/>' +
                '비고사항1 : {REMARK1}<br/>' +
                '비고사항2 : {REMARK2}<br/>' +
                '비고사항3 : {REMARK3}<br/>' +
                '면적(S/F) : {SQUARE_FT}<br/>' +
                '</div>',
            '</div>'      
	  		
        ],
        
        record: null
	};
	
    /**
     * Master Grid
     */ 
	 var masterView = Ext.create('Ext.NavigationView', {
	 	 itemId:'navView',
	 	 width:'100%',
	 	 height:'100%',
	     flex:1,
	     defaultBackButtonText :'목록',
	     /*navigationBar: {
		    ui: 'dark',
		    docked: 'top'
		 },*/
		 items:[
		 	{
		 		title:'품목정보',
		 		height:'100%',
			 	xtype:'list',
			 	id:'bpr103ukrvView',
		    	store : directMasterStore,
		    	width:'100%',
		    	itemTpl: [
		            '<div class="top"><div class="name">{ITEM_NAME}</div>' +
		            '				 <div>분류:{ITEM_LEVEL_NAME1} {ITEM_LEVEL_NAME2} {ITEM_LEVEL_NAME3}<br/>' +
		            '					  규격:{SPEC}<br/>' +
		            '					  단위:{SALE_UNIT}<br/>' +
		            '					  단가:{SALE_BASIS_P}</div></div>'
		        ],
		        listeners:{
		        	itemtap : function( dataView , index , target , record , e , eOpts ) {
		        		var itemView =  Ext.create('Ext.Container', itemViewConf);
		        		itemView.setRecord(record);
		        		dataView.up('#navView').push(itemView);
		        		
		        	},
		        	hide : function(dataView)	{
		        		panelSearch.hide();	
		        	},
		        	show : function(dataView)	{
		        		panelSearch.show();
		        	}
		        }
			  
		 }]
    
});
    
    
	
	
	
        
     	return Ext.create('OmegaPlus.BaseApp', {	  
      	id  : 'bpr103ukrvApp',
		appItems : [
			panelSearch,
			masterView
		]/*,
		fnInitBinding : function(params) {},
	    onQueryButtonDown: function () {		
			directMasterStore.loadStoreRecords();
			
		}*/

		
	});
}
	
	
</script>

