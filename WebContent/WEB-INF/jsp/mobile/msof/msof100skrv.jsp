<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof100skrv"  >
</t:appConfig>
<script type="text/javascript" >
//var detailWin;


function appMain(mainApp) {
	var headerBar = Ext.create('Ext.Container', {    
			itemId: 'headerBar',
			layout: {type: 'hbox', align: 'stretch'},
			style:{
				'line-height':'30px',
				'width':'100%',
				'background-color':'#fff'
			},
			margin : 10,
			spacing:10,
			defaults:{
				labelWidth:80
			},
            items: [{ 
    			xtype: 'button',
    			width:50,
            	text: '메뉴',
            	handler:function()	{
            		window.location.href=CPATH+'/mMain.do';
            	}
            },{
            	xtype:'component',
            	flex:1,
            	html:'<div>&nbsp;</div>'
            },{ 
    			xtype: 'button',
            	text: '등록',
            	width:60,
            	handler:function()	{
            		//window.location.href=CPATH+'/mMain.do';
            	}
            }]
	});
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
	            name: 'ORDER_DATE_FR',  		
    			label: '수주일',
				flex:0.5
    		},{ 
    			xtype: 'textfield',
            	name: 'ORDER_PRSN',  		
            	label: '영업담당',
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
	 Ext.define('sof100skrvModel', {
		extend:'Ext.data.Model',	
		fields: [
			{name: 'DVRY_DATE1'				,text:'납기일'		,type:'date',convert:dateToString},
			{name: 'DVRY_TIME1'				,text:'납기시간'		,type:'string'},
			{name: 'ITEM_CODE'		 		,text:'품목코드' 		,type:'string'},
			{name: 'ITEM_NAME'		 		,text:'품목명' 		,type:'string'},
			{name: 'CUSTOM_CODE1'		 	,text:'거래처코드'		,type:'string'},
			{name: 'CUSTOM_NAME1'		 	,text:'거래처명' 		,type:'string'},
			{name: 'SPEC'			 		,text:'규격' 			,type:'string'},
			{name: 'ORDER_UNIT'		 		,text:'단위' 			,type:'string', displayField: 'value'},
			{name: 'PRICE_TYPE'		 		,text:'단가구분' 		,type:'string'},
			{name: 'TRANS_RATE'		 		,text:'입수' 			,type:'string'},
			{name: 'ORDER_UNIT_Q'	 		,text:'수주량' 		,type:'number'},
			{name: 'ORDER_WGT_Q'	 		,text:'수주량(중량)' 	,type:'number'},
			{name: 'ORDER_VOL_Q'	 		,text:'수주량(부피)' 	,type:'number'},
			{name: 'STOCK_UNIT'		 		,text:'재고단위' 		,type:'string', displayField: 'value'},
			{name: 'STOCK_Q'		 		,text:'재고단위수주량' 	,type:'number'},
			{name: 'MONEY_UNIT'		 		,text:'화폐' 			,type:'string'},
			{name: 'ORDER_P'		 		,text:'단가' 			,type:'number'},
			{name: 'ORDER_WGT_P'	 		,text:'단가(중량)' 	,type:'number'},
			{name: 'ORDER_VOL_P'	 		,text:'단가(부피)' 	,type:'number'},
			{name: 'ORDER_O'		 		,text:'수주액' 		,type:'number'},
			{name: 'EXCHG_RATE_O'	 		,text:'환율' 			,type:'number'},
			{name: 'SO_AMT_WON'		 		,text:'환산액' 		,type:'number'},
			{name: 'TAX_TYPE'		 		,text:'과세여부' 		,type:'string', comboType:'AU', comboCode:'B050'},
			{name: 'ORDER_TAX_O'	 		,text:'세액' 			,type:'number'},
			{name: 'WGT_UNIT'		 		,text:'중량단위' 		,type:'string'},
			{name: 'UNIT_WGT'		 		,text:'단위중량' 		,type:'string'},
			{name: 'VOL_UNIT'		 		,text:'부피단위' 		,type:'string'},
			{name: 'UNIT_VOL'		 		,text:'단위부피' 		,type:'string'},
			{name: 'CUSTOM_CODE2'	 		,text:'거래처코드' 	,type:'string'},
			{name: 'CUSTOM_NAME2'	 		,text:'거래처명' 		,type:'string'},
			{name: 'ORDER_DATE'		 		,text:'수주일' 		,type:'date',convert:dateToString},
			{name: 'ORDER_TYPE'		 		,text:'판매유형' 		,type:'string',comboType:"AU", comboCode:"S002"},
			{name: 'ORDER_TYPE_NM'	 		,text:'판매유형' 		,type:'string'},
			{name: 'ORDER_NUM'		 		,text:'수주번호' 		,type:'string'},
			{name: 'SER_NO'			 		,text:'순번' 			,type:'integer'},
			{name: 'ORDER_PRSN'		 		,text:'영업담당' 		,type:'string',comboType:"AU", comboCode:"S010"},
			{name: 'ORDER_PRSN_NM'	 		,text:'영업담당' 		,type:'string'},
			{name: 'PO_NUM'			 		,text:'P/O NO' 		,type:'string'},
			{name: 'DVRY_DATE2'		 		,text:'납기일' 		,type:'date',convert:dateToString},
			{name: 'DVRY_TIME'		 		,text:'납기시간' 		,type:'date'},
			{name: 'DVRY_CUST_NM'	 		,text:'배송처' 		,type:'string'},
			{name: 'PROD_END_DATE'	 		,text:'생산완료요청일' 	,type:'date',convert:dateToString},
			{name: 'PROD_Q'			 		,text:'생산요청량' 	,type:'number'},
			{name: 'ORDER_STATUS'	 		,text:'마감' 			,type:'string',comboType:"AU", comboCode:"S011"},
			{name: 'REMARK'					,text:'비고'			,type:'string'},
			{name: 'SORT_KEY'		 		,text:'SORTKEY' 	,type:'string'},
			{name: 'CREATE_LOC'		 		,text:'CREATE_LOC' 	,type:'string'}
		]
	});
	function dateToString(v, record){
		return v;
	 }
	/**
	 * Master Store
	 */
	var directMasterStore = Ext.create('Ext.data.Store',{
		
			storeId:'sof100skrvMasterStore',
			proxy: {
	            type: 'direct',
	            api: {
	                read: 'sof100skrvService.selectList1'
	            }
	        },
			model: 'sof100skrvModel',
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
		
        title: '수주현황상세정보',
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
		 		title:'수주현황',
		 		height:'100%',
			 	xtype:'list',
			 	id:'sof100skrvView',
		    	store : directMasterStore,
		    	width:'100%',
		    	itemTpl: [//수주번호, 수주일, 거래처명(코드), 품목명(코드), 단위, 수주량, 단가(화폐), 수주액
		            '<div class="top"><div>수주번호:{ORDER_NUM}<br/>' +
		            '					  수주일:{ORDER_DATE}<br/>' +
		            '					  거래처:{CUSTOM_NAME1}({CUSTOM_CODE1})<br/>' +
		            '					  품목:{ITEM_NAME}({ITEM_CODE})<br/>' +
		            '					  단위:{ORDER_UNIT}<br/>' +
		            '					  수주량:{ORDER_UNIT_Q}<br/>' +
		            '					  단가:{ORDER_P}({MONEY_UNIT})<br/>' +
		            '					  수주액:{ORDER_O}({MONEY_UNIT})</div></div>'
		        ],
		        listeners:{
		        	itemtap : function( dataView , index , target , record , e , eOpts ) {
		        		/*var itemView =  Ext.create('Ext.Container', itemViewConf);
		        		itemView.setRecord(record);
		        		dataView.up('#navView').push(itemView);*/
		        		
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
      	id  : 'sof100skrvApp',
		appItems : [
			headerBar,
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

