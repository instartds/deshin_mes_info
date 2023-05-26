<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="bcm105ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B015" /><!-- 거래처구분    -->  
	<t:ExtComboStore comboType="AU" comboCode="B016" /><!-- 법인/개인-->        
	<t:ExtComboStore comboType="AU" comboCode="B012" /><!-- 국가코드-->         
	<t:ExtComboStore comboType="AU" comboCode="B004" /><!-- 기준화폐-->         
	<t:ExtComboStore comboType="AU" comboCode="B017" /><!-- 원미만계산-->       
	<t:ExtComboStore comboType="AU" comboCode="A022" /><!-- 계산서종류-->       
	<t:ExtComboStore comboType="AU" comboCode="B038" /><!--결제방법-->  	     
	<t:ExtComboStore comboType="AU" comboCode="B034" /><!--결제조건-->         
	<t:ExtComboStore comboType="AU" comboCode="B033" /><!--마감종류-->         
	<t:ExtComboStore comboType="AU" comboCode="B010" /><!--사용여부-->        
	<t:ExtComboStore comboType="AU" comboCode="B030" /><!--세액포함여부-->         
	<t:ExtComboStore comboType="AU" comboCode="B051" /><!--세액계산법-->           
	<t:ExtComboStore comboType="AU" comboCode="B055" /><!--거래처분류-->           
	<t:ExtComboStore comboType="AU" comboCode="B056" /><!--지역구분   -->          
	<t:ExtComboStore comboType="AU" comboCode="B057" /><!--미수관리방법-->         
	<t:ExtComboStore comboType="AU" comboCode="S010" /><!--주담당자  -->           
	<t:ExtComboStore comboType="AU" comboCode="B062" /><!--카렌더타입  -->         
	<t:ExtComboStore comboType="AU" comboCode="B086" /><!--카렌더타입 -->        
	<t:ExtComboStore comboType="AU" comboCode="S051" /><!--전자문서구분 -->        
	<t:ExtComboStore comboType="AU" comboCode="A020" /><!--전자문서주담당여부 -->  
	<t:ExtComboStore comboType="AU" comboCode="B109" /><!--유통채널	--> 
	<t:ExtComboStore comboType="AU" comboCode="B232" /><!--신/구 주소구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="B131" /><!--예/아니오 -->
	
</t:appConfig>
<style type= "text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">
  var protocol =   ("https:" == document.location.protocol)  ? "https" : "http"  ;
  if(protocol == "https")	{
	  document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
  }else {
  	document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
  }
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >
var detailWin;


var BsaCodeInfo = { 
	gsHiddenField: '${gsHiddenField}'
}
var delfag 				= '';


function appMain() {

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('bcm105ukrvModel', {
		// pkGen : user, system(default)
	    fields: [{name: 'CUSTOM_CODE' 		,text:'거래처코드' 		,type:'string'	, isPk:true, pkGen:'user'},
				 {name: 'CUSTOM_TYPE' 		,text:'<t:message code="system.label.base.classfication" default="구분"/>' 			,type:'string'	,comboType:'AU',comboCode:'B015' ,allowBlank: false},
				 {name: 'CUSTOM_NAME' 		,text:'거래처명' 		,type:'string'	,allowBlank:false},
				 {name: 'CUSTOM_NAME1' 		,text:'거래처명1' 		,type:'string'	},
				 {name: 'CUSTOM_NAME2' 		,text:'거래처명2' 		,type:'string'	},
				 {name: 'CUSTOM_FULL_NAME' 	,text:'거래처명(전명)' 	,type:'string'	,allowBlank:false},
				 {name: 'NATION_CODE' 		,text:'국가코드' 		,type:'string'	,comboType:'AU',comboCode:'B012'},
				 {name: 'COMPANY_NUM' 		,text:'사업자번호' 	,type:'string'	},
				 {name: 'TOP_NUM' 			,text:'주민번호' 		,type:'string'	},
				 {name: 'TOP_NAME' 			,text:'대표자' 		,type:'string'	},
				 {name: 'BUSINESS_TYPE' 	,text:'법인/구분' 		,type:'string'	,comboType:'AU',comboCode:'B016'},
				 {name: 'USE_YN' 			,text:'<t:message code="system.label.base.photoflag" default="사진유무"/>' 		,type:'string'	,comboType:'AU',comboCode:'B010', defaultValue:'Y'},
				 {name: 'COMP_TYPE' 		,text:'업태' 			,type:'string'	},
				 {name: 'COMP_CLASS' 		,text:'업종' 			,type:'string'	},
				 {name: 'AGENT_TYPE' 		,text:'거래처분류' 	,type:'string'	,comboType:'AU',comboCode:'B055' ,allowBlank: false},
				 {name: 'AGENT_TYPE2' 		,text:'거래처분류2' 	,type:'string'	},
				 {name: 'AGENT_TYPE3' 		,text:'거래처분류3' 	,type:'string'	},
				 {name: 'AREA_TYPE' 		,text:'지역' 			,type:'string'	,comboType:'AU',comboCode:'B056'},
				 {name: 'ZIP_CODE' 			,text:'우편번호' 		,type:'string'	},
				 {name: 'ADDR1' 			,text:'주소1' 		,type:'string'	},
				 {name: 'ADDR2' 			,text:'주소2' 		,type:'string'	},					
				 {name: 'TELEPHON' 			,text:'연락처' 		,type:'string'	},
				 {name: 'FAX_NUM' 			,text:'FAX번호' 		,type:'string'	},
				 {name: 'HTTP_ADDR' 		,text:'홈페이지' 		,type:'string'	},  
				 {name: 'MAIL_ID' 			,text:'E-mail' 		,type:'string'	},
				 {name: 'WON_CALC_BAS' 		,text:'원미만계산' 	,type:'string'	,comboType:'AU',comboCode:'B017'},
				 {name: 'START_DATE' 		,text:'거래시작일' 	,type:'uniDate'	,allowBlank: false, defaultValue:UniDate.today()},
				 {name: 'STOP_DATE' 		,text:'거래중단일' 	,type:'uniDate'	},
				 {name: 'TO_ADDRESS' 		,text:'송신주소' 		,type:'string'	},
				 {name: 'TAX_CALC_TYPE' 	,text:'세액계산법' 	,type:'string'	,comboType:'AU',comboCode:'B051', defaultValue:'1'},
				 {name: 'RECEIPT_DAY' 		,text:'결제기간' 		,type:'string'	,comboType:'AU',comboCode:'B034'},
				 {name: 'MONEY_UNIT' 		,text:'기준화폐' 		,type:'string'	, comboType:'AU',comboCode:'B004', displayField: 'value'},
				 {name: 'TAX_TYPE' 			,text:'세액포함여부' 	,type:'string'	, comboType:'AU',comboCode:'B030', defaultValue:'1'},
				 {name: 'BILL_TYPE' 		,text:'계산서유형' 	,type:'string'	, comboType:'AU',comboCode:'A022'},
				 {name: 'SET_METH' 			,text:'결제방법' 		,type:'string'	, comboType:'AU',comboCode:'B038'},
				 {name: 'VAT_RATE' 			,text:'세율' 			,type:'uniFC'	,defaultValue:0},
				 {name: 'TRANS_CLOSE_DAY' 	,text:'마감종류' 		,type:'string'	, comboType:'AU',comboCode:'B033'},
				 {name: 'COLLECT_DAY' 		,text:'수금일'  		,type:'integer' ,defaultValue:1, minValue:1},                  
				 {name: 'CREDIT_YN' 		,text:'여신적용여부' 	,type:'string'	, comboType:'AU',comboCode:'B010'},
				 {name: 'TOT_CREDIT_AMT' 	,text:'여신(담보)액' 	,type:'uniPrice'	},
				 {name: 'CREDIT_AMT' 		,text:'신용여신액' 	,type:'uniPrice'	},
				 {name: 'CREDIT_YMD' 		,text:'신용여신만료일' 	,type:'uniDate'	},
				 {name: 'COLLECT_CARE' 		,text:'미수관리방법' 	,type:'string'	, comboType:'AU',comboCode:'B057', defaultValue:'1'},
				 {name: 'BUSI_PRSN' 		,text:'주담당자' 		,type:'string'	, comboType:'AU',comboCode:'S010'},
				 {name: 'CAL_TYPE' 			,text:'카렌더타입' 	,type:'string'	, comboType:'AU',comboCode:'B062'},
				 {name: 'REMARK' 			,text:'<t:message code="system.label.base.remarks" default="비고"/>' 			,type:'string'	},
				 {name: 'MANAGE_CUSTOM' 	,text:'집계거래처' 	,type:'string'	},					
				 {name: 'MCUSTOM_NAME' 		,text:'집계거래처명' 	,type:'string'	},
				 {name: 'COLLECTOR_CP' 		,text:'수금거래처' 	,type:'string'	},					
				 {name: 'COLLECTOR_CP_NAME' ,text:'수금거래처명' 	,type:'string'	},					
				 {name: 'BANK_CODE' 		,text:'금융기관' 		,type:'string'	},
				 {name: 'BANK_NAME' 		,text:'금융기관명' 	,type:'string'	},
				 {name: 'BANKBOOK_NUM' 		,text:'계좌번호' 		,type:'string'	},
				 {name: 'BANKBOOK_NAME' 	,text:'예금주' 		,type:'string'	},
				 {name: 'CUST_CHK' 			,text:'거래처변경여부' 	,type:'string'	},
				 {name: 'SSN_CHK' 			,text:'주민번호변경여부',type:'string'	},
				 {name: 'UPDATE_DB_USER' 	,text:'작성자' 		,type:'string'	},
				 {name: 'UPDATE_DB_TIME' 	,text:'작성시간' 		,type:'uniDate'	},
				 {name: 'PURCHASE_BANK' 	,text:'구매카드은행' 	,type:'string'	},
				 {name: 'PURBANKNAME' 		,text:'구매카드은행명' 	,type:'string'	},
				 {name: 'BILL_PRSN' 		,text:'전자문서담당자' 	,type:'string'	},
				 {name: 'HAND_PHON' 		,text:'핸드폰번호' 	,type:'string'	},
				 {name: 'BILL_MAIL_ID' 		,text:'전자문서E-mail'	,type:'string'	},
				 {name: 'BILL_PRSN2' 		,text:'전자문서담당자2' ,type:'string'	},
				 {name: 'HAND_PHON2' 		,text:'핸드폰번호2' 	,type:'string'	},
				 {name: 'BILL_MAIL_ID2' 	,text:'전자문서E-mail2'	,type:'string'	},
				 {name: 'BILL_MEM_TYPE' 	,text:'전자세금계산서' 		,type:'string'	},
				 {name: 'ADDR_TYPE' 		,text:'신/구주소 구분' 		,type:'string'	, comboType:'AU',comboCode:'B232'},
				 {name: 'COMP_CODE' 		,text:'COMP_CODE' 		,type:'string'	, defaultValue: UserInfo.compCode},
				 {name: 'CHANNEL' 			,text:'CHANNEL' 		,type:'string'	},
				 {name: 'BILL_CUSTOM' 		,text:'계산서거래처코드'		,type:'string'	},
				 {name: 'BILL_CUSTOM_NAME' 	,text:'계산서거래처' 	  	,type:'string'	},
				 {name: 'CREDIT_OVER_YN' 	,text:'CREDIT_OVER_YN' 	,type:'string'	},
				 {name: 'Flag' 				,text:'Flag' 			,type:'string'	,defaultValue:'U'},    
				 {name: 'DEPT_CODE' 		,text:'관련부서' 			,type:'string'	},    
				 {name: 'DEPT_NAME' 		,text:'관련부서명' 		,type:'string'	},
				 {name: 'BILL_PUBLISH_TYPE' 		,text:'전자세금계산서발행유형' 		,type:'string'	, defaultValue:'1'}, //임시 2016.11.07
				 // 추가(극동)   
                 {name: 'R_PAYMENT_YN'      ,text:'정기결제여부'    ,type:'string', defaultValue:'N', allowBlank: false , comboType:'AU',comboCode:'B010' },    
                 {name: 'DELIVERY_METH'     ,text:'운송방법'        ,type:'string'  }
                 //
					
			]
	});

	//SUB 모델 (BCM130T - 계좌정보)
	Unilite.defineModel('bcm100ukrvModel2', {
		fields: [ 
			{name: 'COMPC_CODE'	 		,text: '<t:message code="system.label.base.companycode" default="법인코드"/>' 				,type: 'string'},
			{name: 'CUSTOM_CODE' 		,text: '거래처코드' 			,type: 'string'},
			{name: 'SEQ'			 	,text: '<t:message code="system.label.base.seq" default="순번"/>' 				,type: 'int'}, 
            {name: 'BOOK_CODE'          ,text: '계좌코드'              ,type: 'string', allowBlank:false},
            {name: 'BOOK_NAME'          ,text: '계좌명'               ,type: 'string', allowBlank:false},
			{name: 'BANK_CODE'	 		,text: '은행코드' 				,type: 'string'},
			{name: 'BANK_NAME'	 		,text: '은행명' 				,type: 'string'},
			{name: 'BANKBOOK_NUM'	 	,text: '계좌번호' 				,type: 'string', allowBlank:false}, 
			{name: 'BANKBOOK_NUM_EXPOS'	, text: '계좌번호'		 		,type: 'string', allowBlank:false,  defaultValue: '***************'},
			{name: 'BANKBOOK_NAME'	 	,text: '예금주' 				,type: 'string'},
			{name: 'MAIN_BOOK_YN'       ,text: '주지급계좌'            ,type: 'string', allowBlank:false, comboType:'AU',comboCode:'B131'}
		]
	});	
	
	//SUB 모델 (BCM120T - 전자문서정보)
    Unilite.defineModel('bcm100ukrvModel3', {
        fields: [ 
            {name: 'COMP_CODE'             ,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'            ,type: 'string'},
            {name: 'CUSTOM_CODE'           ,text: '거래처코드'           ,type: 'string', allowBlank:false},
            {name: 'SEQ'                   ,text: '<t:message code="system.label.base.seq" default="순번"/>'               ,type: 'int'},
            {name: 'PRSN_NAME'             ,text: '담당자명'            ,type: 'string'},
            {name: 'DEPT_NAME'             ,text: '부서명'             ,type: 'string'},
            {name: 'HAND_PHON'             ,text: '핸드폰번호'          ,type: 'string'},
            {name: 'TELEPHONE_NUM1'        ,text: '전화번호1'           ,type: 'string'},
            {name: 'TELEPHONE_NUM2'        ,text: '전화번호2'           ,type: 'string'},
            {name: 'FAX_NUM'               ,text: '팩스번호'            ,type: 'string'},
            {name: 'MAIL_ID'               ,text: 'E-MAIL주소'         ,type: 'string', allowBlank:false},
            {name: 'BILL_TYPE'             ,text: '전자문서구분'         ,type: 'string', comboType:'AU',comboCode:'S051'},
            {name: 'MAIN_BILL_YN'          ,text: '전자문서담당자여부'     ,type: 'string', allowBlank:false, comboType:'AU',comboCode:'A020', defaultValue:'N'},
            {name: 'REMARK'                ,text: '<t:message code="system.label.base.remarks" default="비고"/>'               ,type: 'string'}
        ]
    }); 
    

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm105ukrvService.selectList'/*,
			update	: 'bcm100ukrvService.updateDetail',
			create	: 'bcm100ukrvService.insertDetail',
			destroy	: 'bcm100ukrvService.deleteDetail',
			syncAll	: 'bcm100ukrvService.saveAll'*/
		}
	});	 
	
	//SUB 프록시 (BCM130T - 계좌정보)
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'bcm100ukrvService.getBankBookInfo',
			update	: 'bcm100ukrvService.updateList',
			create	: 'bcm100ukrvService.insertList',
			destroy	: 'bcm100ukrvService.deleteList',
			syncAll	: 'bcm100ukrvService.saveAll2'
		}
	});	
	//SUB 프록시 (BCM120T - 전자문서정보)
    var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 'bcm100ukrvService.getSubInfo3',
            update  : 'bcm100ukrvService.updateList3',
            create  : 'bcm100ukrvService.insertList3',
            destroy : 'bcm100ukrvService.deleteList3',
            syncAll : 'bcm100ukrvService.saveAll3'
        }
    }); 
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	//var directMasterStore = Unilite.createStore('bcm105ukrvMasterStore',{
		
	var directMasterStore = Ext.create('Ext.data.BufferedStore',{
			storeId : 'bcm105ukrvMasterStore',	
			model: 'bcm105ukrvModel',
            autoLoad: false,
            
            proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            
	            api: {			
	        	   read: 'bcm105ukrvService.selectList'                 	
	            },
	            reader: {
	                rootProperty: 'records',
	                totalProperty: 'total'
	            },
	            extraParams:{
	            	'Init':true
	            }
	        }),
            
            pageSize: 1000,
		    leadingBufferZone:10000,
		    trailingBufferZone:1000,
		    scrollToLoadBuffer:1000,
		    //numFromEdge:20,
		    clearOnPageLoad:true,
		
		    isSortable: true,
	    	buffered :true,
	    	remoteSort: true, 
	    	addProxyParams:function(form, params)	{
	        	var formParams = form != null ? form.getValues():{};
	        	if(params)	{
	        		Ext.apply(formParams, params);
	        	}
	        	this.getProxy().setExtraParams(formParams)
	        },
            listeners: {
            	update:function( store, record, operation, modifiedFieldNames, eOpts )	{
					//detailForm.setActiveRecord(record);
				},
				metachange:function( store, meta, eOpts ){
					
				}
            	
            }, // listeners
            
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			loadStoreRecords : function()	{
				this.addProxyParams(Ext.getCmp('bcm105ukrvSearchForm'));
				this.load();
			}
		});	
		
	var directMasterStore2 = Unilite.createStore('bcm100ukrvMasterStore2',{
		model: 'bcm100ukrvModel2',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,		// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        
        proxy: directProxy2,
        
        listeners: {
        	update:function( store, record, operation, modifiedFieldNames, eOpts )	{
			},
			
			metachange:function( store, meta, eOpts ){
			}
        },
        
        loadStoreRecords : function(getCustomCode)	{
			var param= Ext.getCmp('bcm105ukrvSearchForm').getValues();
			param.CUSTOM_CODE = getCustomCode
						                    	

			console.log( param );
			this.load({
				params : param
			});
		},
		
		saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect(config);
			}else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
	    _onStoreUpdate: function (store, eOpt) {	    	
	    	console.log("Store data updated save btn enabled !");
	    	this.setToolbarButtons('sub_save', true);    	
	    } // onStoreUpdate

	    ,_onStoreLoad: function ( store, records, successful, eOpts ) {	    	
	    	console.log("onStoreLoad");
	    	if (records) {
		    	this.setToolbarButtons('sub_save', false);
	    	}	    	
	    },
		_onStoreDataChanged: function( store, eOpts )	{	    	
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			this.setToolbarButtons(['sub_delete'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':false}});
       		}else {
       			if(this.uniOpt.deletable)	{
	       			this.setToolbarButtons(['sub_delete'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':true}});
       			}
       		}
       		
       		if(store.isDirty())	{
       			this.setToolbarButtons(['sub_save'], true);
       		}else {
       			this.setToolbarButtons(['sub_save'], false);
       		}	    	
    	},
    	
    	setToolbarButtons: function( btnName, state)	{
    		var toolbar = masterGrid2.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
    	}
        
	});
	
	var directMasterStore3 = Unilite.createStore('bcm100ukrvMasterStore3',{
        model: 'bcm100ukrvModel3',
        autoLoad: false,
        uniOpt : {
            isMaster: false,        // 상위 버튼 연결 
            editable: true,         // 수정 모드 사용 
            deletable:true,         // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        
        proxy: directProxy3,
        
        listeners: {
            update:function( store, record, operation, modifiedFieldNames, eOpts )  {
            },
            
            metachange:function( store, meta, eOpts ){
            }
        },
        
        loadStoreRecords : function(getCustomCode)  {
            var param= Ext.getCmp('bcm105ukrvSearchForm').getValues();
            param.CUSTOM_CODE = getCustomCode
                                                

            console.log( param );
            this.load({
                params : param
            });
        },
        
        saveStore : function(config)    {               
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);
            if(inValidRecs.length == 0 )    {
                this.syncAllDirect(config);
            }else {
                masterGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        
        _onStoreUpdate: function (store, eOpt) {            
            console.log("Store data updated save btn enabled !");
            this.setToolbarButtons('sub_save3', true);       
        } // onStoreUpdate

        ,_onStoreLoad: function ( store, records, successful, eOpts ) {         
            console.log("onStoreLoad");
            if (records) {
                this.setToolbarButtons('sub_save3', false);
            }           
        },
        _onStoreDataChanged: function( store, eOpts )   {           
            console.log("_onStoreDataChanged store.count() : ", store.count());
            if(store.count() == 0)  {
                this.setToolbarButtons(['sub_delete3'], false);
                Ext.apply(this.uniOpt.state, {'btn':{'sub_delete3':false}});
            }else {
                if(this.uniOpt.deletable)   {
                    this.setToolbarButtons(['sub_delete3'], true);
                    Ext.apply(this.uniOpt.state, {'btn':{'sub_delete3':true}});
                }
            }
            
            if(store.isDirty()) {
                this.setToolbarButtons(['sub_save3'], true);
            }else {
                this.setToolbarButtons(['sub_save3'], false);
            }           
        },
        
        setToolbarButtons: function( btnName, state)    {
            var toolbar = masterGrid3.getDockedItems('toolbar[dock="top"]');
            var obj = toolbar[0].getComponent(btnName);
            if(obj) {
                (state) ? obj.enable():obj.disable();
            }
        }
        
    });
	/**
	 * 전자세금계산서 모델 정의
	 */
	Unilite.defineModel('bcm120ukrvModel', {
	    extend: 'Ext.data.Model',
	    fields: [{name: 'COMP_CODE' 		,text:'법인' 				,type:'string'	,allowBlank: false	},
				 {name: 'CUSTOM_CODE' 		,text:'거래처코드' 		,type:'string'	,allowBlank: false	},
				 {name: 'SEQ' 				,text:'<t:message code="system.label.base.seq" default="순번"/>' 				,type:'integer'	,allowBlank: false	},
				 {name: 'PRSN_NAME' 		,text:'담당자명' 			,type:'string'	,allowBlank: false	},
				 {name: 'DEPT_NAME' 		,text:'부서명' 			,type:'string'	},
				 {name: 'HAND_PHON' 		,text:'핸드폰번호' 		,type:'string'	},
				 {name: 'TELEPHONE_NUM1' 	,text:'전화번호1' 			,type:'string'	,allowBlank: false	},
				 {name: 'TELEPHONE_NUM2' 	,text:'전화번호2' 			,type:'string'	},
				 {name: 'FAX_NUM' 			,text:'팩스번호' 			,type:'string'	},
				 {name: 'MAIL_ID' 			,text:'E-MAIL주소' 		,type:'string'	,allowBlank: false	},
				 {name: 'BILL_TYPE' 		,text:'전자문서구분'		,type:'string'	, comboType:'AU',comboCode:'S051'},
				 {name: 'MAIN_BILL_YN' 		,text:'전자문서주담당자여부'  ,type:'string'	, comboType:'AU',comboCode:'A020'	,allowBlank: false},
				 {name: 'REMARK' 			,text:'<t:message code="system.label.base.remarks" default="비고"/>' 				,type:'string'	}
			]
	});
	
  

	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('bcm105ukrvSearchForm',{
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		defaultType: 'uniSearchSubPanel',
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		defaults: {
			autoScroll:true
	  	},
		items:[{
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items:[{	    
				fieldLabel: '거래처코드',
				name: 'CUSTOM_CODE',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CUSTOM_CODE', newValue);
					}
				}
			},{
			    fieldLabel: '거래처명',
				name: 'CUSTOM_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>',
				name: 'CUSTOM_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'B015',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CUSTOM_TYPE', newValue);
					}
				}
			}]
		}, {			
		 	title:'<t:message code="system.label.base.additionalinfo" default="추가정보"/>',
   			id: 'search_panel2',
			itemId:'search_panel2',
        	defaultType: 'uniTextfield',
        	layout: {type: 'uniTable', columns: 1},
		 	items: [{
				fieldLabel: '지역',
				name: 'AREA_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'B056'
			},{
				fieldLabel: '주영업담당',
				name: 'BUSI_PRSN' ,          
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'S010' 
			},{
				fieldLabel: '고객분류'    ,
				name: 'AGENT_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'B055' 
			},{
				fieldLabel: '법인/개인',
				name: 'BUSINESS_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'B016' 
			},{
				fieldLabel: '<t:message code="system.label.base.photoflag" default="사진유무"/>'     ,
				name: 'USE_YN',
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'B010' 
			},{
				fieldLabel: '대표자명'     ,
				name: 'TOP_NAME'
			},{
				fieldLabel: '사업자번호',
				name: 'COMPANY_NUM'
		    }/*,{
				fieldLabel: '사업자번호체크' ,
				name: 'CHK_COMPANY_NUM' ,
				xtype: 'checkboxfield'                  
	    	}*/]	            			             			 
		}]
	});	//end panelSearch    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{	    
			fieldLabel: '거래처코드',
			name: 'CUSTOM_CODE',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CUSTOM_CODE', newValue);
				}
			}
		},{
		    fieldLabel: '거래처명',
			name: 'CUSTOM_NAME',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CUSTOM_NAME', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>',
			name: 'CUSTOM_TYPE' ,
			xtype: 'uniCombobox' ,
			comboType: 'AU',
			comboCode: 'B015',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CUSTOM_TYPE', newValue);
				}
			}
		}]	
    });
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('bcm105ukrvGrid', {
    	region:'center',
    	store: directMasterStore,
        layout : 'fit',        
        sortableColumns : false,
		uniOpt:{		
		    useLiveSearch		: false,
        	expandLastColumn: false,
            useMultipleSorting: true,
            onLoadSelectFirst	: false,
            excel: {
				useExcel: false,			//엑셀 다운로드 사용 여부
				exportGroup : false, 		//group 상태로 export 여부
				onlyData:false
			},
			state: {
 				useState		: false,		//그리드 설정 버튼 사용 여부
 				useStateList	: false		//그리드 설정 목록 사용 여부
			}
        },
        tbar:[

          ],
        border:true,
//        tbar: [
//	            {
//	        	text:'상세보기',
//	        	handler: function() {
//	        		var record = masterGrid.getSelectedRecord();
//		        	if(record) {
//		        		openDetailWindow(record);
//		        	}
//	        	}
//        }],
		columns:[{dataIndex:'CUSTOM_CODE'		,width:80, hideable:false, isLink:true},
				 {dataIndex:'CUSTOM_TYPE'		,width:80, hideable:false},
				 {dataIndex:'CUSTOM_NAME'		,width:170,hideable:false},
				 {dataIndex:'CUSTOM_NAME1'		,width:150	, hidden:true},
				 {dataIndex:'CUSTOM_NAME2'		,width:150	, hidden:true},
				 {dataIndex:'CUSTOM_FULL_NAME'	,width:170},
				 {dataIndex:'NATION_CODE'		,width:130	, hidden:true},
				 {dataIndex:'COMPANY_NUM'		,width:100},
				 {dataIndex:'TOP_NUM'			,width:100	, hidden:true},
				 {dataIndex:'TOP_NAME'			,width:100},
				 {dataIndex:'BUSINESS_TYPE'		,width:110	, hidden:true},
				 {dataIndex:'USE_YN'			,width:60	, hidden:true},
				 {dataIndex:'COMP_TYPE'			,width:140},
				 {dataIndex:'COMP_CLASS'		,width:140},
				 {dataIndex:'AGENT_TYPE'		,width:120},
				 {dataIndex:'AGENT_TYPE2'		,width:80	, hidden:true},
				 {dataIndex:'AGENT_TYPE3'		,width:80	, hidden:true},
				 {dataIndex:'AREA_TYPE'			,width:80	, hidden:true},
				 {dataIndex:'ZIP_CODE'			, hidden : true
					,'editor' : Unilite.popup('ZIP_G',{
			  						autoPopup: true,
			  						listeners: {
						                'onSelected': {
						                    fn: function(records, type  ){
						                    	var me = this;
						                    	var grdRecord = Ext.getCmp('bcm105ukrvGrid').uniOpt.currentRecord;
						                    	grdRecord.set('ADDR1',records[0]['ZIP_NAME']);
						                    	grdRecord.set('ADDR2',records[0]['ADDR2']);
						                    },
						                    scope: this
						                },
						                'onClear' : function(type){
						                		var me = this;
						                    	var grdRecord = Ext.getCmp('bcm105ukrvGrid').uniOpt.currentRecord;
						                    	grdRecord.set('ADDR1','');
						                    	grdRecord.set('ADDR2','');
						                }
						            }
								})},
				 {dataIndex:'ADDR1'				,width:200	, hidden:true},
				 {dataIndex:'ADDR2'				,width:200	, hidden:true},
				 {dataIndex:'TELEPHON'			,width:80},
				 // 추가(극동)
                 {dataIndex:'R_PAYMENT_YN'      ,width:100	, hidden:true},  
                 {dataIndex:'DELIVERY_METH'     ,width:80	, hidden:true},
                 //
				 {dataIndex:'FAX_NUM'			,width:80	, hidden:true},
				 {dataIndex:'HTTP_ADDR'			,width:140	, hidden:true},
				 {dataIndex:'MAIL_ID'			,width:100	, hidden:true},
				 {dataIndex:'WON_CALC_BAS'		,width:80	, hidden:true},
				 {dataIndex:'START_DATE'		,width:110	, hidden:true},
				 {dataIndex:'STOP_DATE'			,width:110	, hidden:true},
				 {dataIndex:'TO_ADDRESS'		,width:140	, hidden:true},
				 {dataIndex:'TAX_CALC_TYPE'		,width:90	, hidden:true},
				 {dataIndex:'TRANS_CLOSE_DAY'	,width:120	, hidden:true},
				 {dataIndex:'RECEIPT_DAY'		,width:120	, hidden:true},
				 {dataIndex:'MONEY_UNIT'		,width:130	, hidden:true},
				 {dataIndex:'TAX_TYPE'			,width:90	, hidden:true},
				 {dataIndex:'BILL_TYPE'			,width:120	, hidden:true},
				 {dataIndex:'SET_METH'			,width:90	, hidden:true},
				 {dataIndex:'VAT_RATE'			,width:60	, hidden:true},
				 {dataIndex:'TRANS_CLOSE_DAY'	,width:90	, hidden:true},
				 {dataIndex:'COLLECT_DAY'		,width:90	, hidden:true, maxValue: 31, minValue: 1},
				 {dataIndex:'CREDIT_YN'			,width:80	, hidden:true},
				 {dataIndex:'TOT_CREDIT_AMT'	,width:90	, hidden:true},
				 {dataIndex:'CREDIT_AMT'		,width:80	, hidden:true},
				 {dataIndex:'CREDIT_YMD'		,width:110	, hidden:true},
				 {dataIndex:'COLLECT_CARE'		,width:120	, hidden:true},
				 {dataIndex:'BUSI_PRSN'			,width:90	, hidden:true},
				 {dataIndex:'CAL_TYPE'			,width:110	, hidden:true},
				 {dataIndex:'REMARK'			,width:250	, flex:1},
				 {dataIndex:'MANAGE_CUSTOM'		,width:140	, hidden:true},
				 {dataIndex:'MCUSTOM_NAME'		,width:140	, hidden:true
				  ,editor : Unilite.popup('CUST_G',{						            
				    				textFieldName:'MCUSTOM_NAME',
			  						autoPopup: true,
				    				listeners: {
						                'onSelected':  function(records, type  ){
						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
						                    	grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
						                    	grdRecord.set('MCUSTOM_NAME',records[0]['CUSTOM_NAME']);
						                }
						                ,'onClear':  function( type  ){
						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
						                    	grdRecord.set('MCUSTOM_NAME','');
						                    	grdRecord.set('MANAGE_CUSTOM','');
						                }
						            } // listeners
								}) 		
				},
				 {dataIndex:'COLLECTOR_CP'	,width:140	, hidden:true},
				 {dataIndex:'COLLECTOR_CP_NAME'	,width:140	, hidden:true
					,'editor' : Unilite.popup('CUST_G',	{				            
				    					textFieldName:'COLLECTOR_CP_NAME', 
			  							autoPopup: true,
					    				listeners: {
							                'onSelected':  function(records, type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('COLLECTOR_CP',records[0]['CUSTOM_CODE']);
							                   		grdRecord.set('COLLECTOR_CP_NAME',records[0]['CUSTOM_NAME']);
							                },
							                'onClear':  function( type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('COLLECTOR_CP_NAME','');
							                    	grdRecord.set('COLLECTOR_CP','');
							                }
							            } // listeners
								}) 		
				},
				 {dataIndex:'BANK_NAME',  width: 100   	, hidden: true
						,'editor' : Unilite.popup('BANK_G',	{			            
										textFieldName:'BANK_NAME',
			  							autoPopup: true,
				    					listeners: {
							                'onSelected': function(records, type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
							                    	grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
							                },
							                'onClear':  function( type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('BANK_NAME','');
							                    	grdRecord.set('BANK_CODE','');
							                }
						            	} // listeners
								}) 		
					}, 
				        
				 {dataIndex:'BANKBOOK_NUM'		,width:100	, hidden:true},
				 {dataIndex:'BANKBOOK_NAME'		,width:100	, hidden:true},
				 {dataIndex:'CUST_CHK'			,width:90	, hidden:true},
				 {dataIndex:'SSN_CHK'			,width:90	, hidden:true},
				 {dataIndex:'UPDATE_DB_USER'	,width:90	, hidden:true},
				 {dataIndex:'UPDATE_DB_TIME'	,width:90	, hidden:true},
				 {dataIndex:'PURCHASE_BANK'		,width:150	, hidden:true},
				 {dataIndex:'PURBANKNAME'		,width:150	, hidden:true},
				 {dataIndex:'BILL_PRSN'			,width:110	, hidden:true},
				 {dataIndex:'HAND_PHON'			,width:110	, hidden:true},
				 {dataIndex:'BILL_MAIL_ID'		,width:140	, hidden:true},
				 {dataIndex:'ADDR_TYPE'			,width:120	, hidden:true},
				 {dataIndex:'CHANNEL'			,width:80	, hidden:true},
				 {dataIndex:'BILL_CUSTOM'	,width:120	, hidden:true},
				 {dataIndex:'BILL_PUBLISH_TYPE'	,width:120	, hidden:true}, //임시
				 {dataIndex:'BILL_CUSTOM_NAME'	,width:120	, hidden:true
					,'editor' : Unilite.popup('CUST_G',{	            
										textFieldName:'BILL_CUSTOM_NAME',
			  							autoPopup: true,
										listeners: {	
							                'onSelected':  function(records, type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('BILL_CUSTOM',records[0]['CUSTOM_CODE']);
							                    	grdRecord.set('BILL_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
							                },
							                'onClear':  function( type  ){
							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    	grdRecord.set('BILL_CUSTOM_NAME','');
							                    	grdRecord.set('BILL_CUSTOM','');
							                }
						            	} //listeners
								}) 		
				 } 
				
				
          ]
         , 
         listeners: {
             //각주 이미지 툴바에 정의
             render:function(grid, eOpt) {
                 grid.getEl().on('click', function(e, t, eOpt) {
                     activeGrid = grid.getItemId();
                 });
                 var i=0;
                 var tbar = grid._getToolBar();
                 tbar[0].insert(i++, {
                     xtype: 'uniBaseButton',
                     iconCls: 'icon-excel',
                     width: 26, 
                     height: 26,
                     tooltip: '엑셀 다운로드',
                     handler: function() { 
                         var form = panelFileDown;

                         form.setValue('CUSTOM_CODE',    panelSearch.getValue('CUSTOM_CODE'));
                         form.setValue('CUSTOM_NAME',    panelSearch.getValue('CUSTOM_NAME'));
                         form.setValue('CUSTOM_TYPE',    panelSearch.getValue('CUSTOM_TYPE'));
                         
                         var param = form.getValues();
                         
                         form.submit({
                             params: param,
                             success:function(comp, action)  {
                                 Ext.getBody().unmask();
                             },
                             failure: function(form, action){
                                 Ext.getBody().unmask();
                             }                   
                         }); 
                     }
                 });
             },
          	selectionchangerecord:function(selected)	{
          		//detailForm.setActiveRecord(selected);
          		detailForm.uniOpt.inLoading = true;
          		detailForm.loadRecord(selected);
          		detailForm.uniOpt.inLoading = false;
				directMasterStore2.loadStoreRecords(selected.get('CUSTOM_CODE'));
                directMasterStore3.loadStoreRecords(selected.get('CUSTOM_CODE'));
          	},
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
//          			Ext.getCmp('CUSTOM_CODE_READONLY').setReadOnly(true);
	      			switch(colName)	{
					case 'CUSTOM_CODE' :
							masterGrid.hide();
							break;		
					default:
							break;
	      			}
          		} else {
//          		    Ext.getCmp('CUSTOM_CODE_READONLY').setReadOnly(false);
          		}
          	},
			hide:function()	{
				var selected = masterGrid.getSelectedRecord();
				if(selected)	{
					detailForm.setDisabled(false);
					detailForm.getField("CUSTOM_CODE").setReadOnly(true);
					detailForm.uniOpt.inLoading = true;
					detailForm.loadRecord(selected);
					detailForm.uniOpt.inLoading = false;
					directMasterStore2.loadStoreRecords(selected.get('CUSTOM_CODE'));
                	directMasterStore3.loadStoreRecords(selected.get('CUSTOM_CODE'));
				}
				detailForm.show();
				detailComponent.show();
				UniAppManager.setToolbarButtons('delete',true);	
			}
          } 
    });


    var panelFileDown = Unilite.createForm('ExcelFileDownForm', {
        url: CPATH+'/accnt/bcm105excel.do',
        colspan: 2,
        layout: {type: 'uniTable', columns: 1},
        height: 30,
        padding: '0 0 0 0',
        disabled:false,
        autoScroll: false,
        standardSubmit: true,  
        items:[{
            xtype: 'uniTextfield',
            name: 'CUSTOM_CODE'
        },{
            xtype: 'uniTextfield',
            name: 'CUSTOM_NAME'
        },{
            xtype: 'uniTextfield',
            name: 'CUSTOM_TYPE'
        }]
    });
    
    var masterGrid2 = Unilite.createGrid('bcm105ukrvGrid2', {    	
    	store	: directMasterStore2,
    	border	: true,
    	height	: 150,
    	width	: 912,
    	sortableColumns : false,
    	
    	excelTitle: '계좌정보',
    	uniOpt:{
			 expandLastColumn	: true,
			 useRowNumberer		: true,
			 useMultipleSorting	: false,
			 enterKeyCreateRow	: false	/*,
			 useNavigationModel:false*/
    	},
    	dockedItems	: [{    		
	        xtype	: 'toolbar',
	        dock	: 'top',
	        items	: [{
                xtype	: 'uniBaseButton',
		 		text 	: '조회',
		 		tooltip	: '조회',
		 		iconCls	: 'icon-query', 
		 		width	: 26,
		 		height	: 26,
		 		itemId	: 'sub_query',
				handler: function() { 
					//if( me._needSave()) {
					var toolbar = masterGrid2.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					var record = masterGrid.getSelectedRecord();
					if(needSave) {
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	//console.log(res);
						     	if (res === 'yes' ) {
						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
				                  		directMasterStore2.saveStore();
				                    });
				                    saveTask.delay(500);
						     	} else if(res === 'no') {
						     		directMasterStore2.loadStoreRecords(record.get('CUSTOM_CODE'));
						     	}
						     }
						});
					} else {
						directMasterStore2.loadStoreRecords(record.get('CUSTOM_CODE'));
					}
				}
			},{
                xtype	: 'uniBaseButton',
				text	: '신규',
				tooltip : '초기화',
				iconCls	: 'icon-reset',
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_reset',
				handler	: function() { 
					var toolbar = masterGrid2.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					if(needSave) {
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	console.log(res);
						     	if (res === 'yes' ) {
						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
					                  	directMasterStore2.saveStore();
					                });
					                saveTask.delay(500);
						     	} else if(res === 'no') {
						     		masterGrid2.reset();
						     		directMasterStore2.clearData();
						     		directMasterStore2.setToolbarButtons('sub_save', false);
						     		directMasterStore2.setToolbarButtons('sub_delete', false);
						     	}
						     }
						});
					} else {
						masterGrid2.reset();
						directMasterStore2.clearData();
						directMasterStore2.setToolbarButtons('sub_save', false);
						directMasterStore2.setToolbarButtons('sub_delete', false);
					}					
				}
			},{
                xtype	: 'uniBaseButton',
				text	: '추가',
				tooltip	: '추가',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_newData',
				handler	: function() { 
					
					var compCode	= UserInfo.compCode;  
					var customCode	= detailForm.getValue('CUSTOM_CODE');
					var bankBookNumExpos  = '';
					if(!Ext.isEmpty(customCode))	{
						var mainBookYn  = 'N'; 
						
						
		            	var r = {
		            	 	COMP_CODE:			compCode,
		            	 	CUSTOM_CODE:		customCode,
		            	 	MAIN_BOOK_YN:       mainBookYn,
		            	 	BANKBOOK_NUM_EXPOS : bankBookNumExpos
				        };
						masterGrid2.createRow(r);
					}else {
                    	Unilite.messageBox("거래처 코드를 입력하세요.")
                    }
				}
			},{
				xtype	: 'uniBaseButton',
				text	: '삭제',
				tooltip	: '삭제',
				iconCls	: 'icon-delete',
				disabled: true,
				width	: 26, 
				height	: 26,
		 		itemId	: 'sub_delete',
				handler	: function() { 
					var selRow = masterGrid2.getSelectedRecord();
					if(selRow.phantom === true)	{
						masterGrid2.deleteSelectedRow();
					}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						masterGrid2.deleteSelectedRow();						
					}	
				}				
			},{
                xtype	: 'uniBaseButton',
				text	: '저장', 
				tooltip	: '저장', 
				iconCls	: 'icon-save',
				disabled: true,
				width	: 26,
				height	: 26,
		 		itemId	: 'sub_save',
				handler : function() {
					var inValidRecs = directMasterStore2.getInvalidRecords();       	
					if(inValidRecs.length == 0 )	{
						var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
	                  		directMasterStore2.saveStore();
						});
						saveTask.delay(500);
					} else {
						masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
					}                  
                }
			}]
	    }],

		columns:  [  
            { dataIndex: 'BOOK_CODE'            ,       width: 120},
            { dataIndex: 'BOOK_NAME'            ,       width: 100},
            
        	{ dataIndex: 'BANK_CODE'	 		,  		width: 120,
				editor: Unilite.popup('BANK_G',{
 	 				DBtextFieldName: 'BANK_CODE',
 	 				autoPopup: true,
					listeners:{ 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
							grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
	                    },
	                    scope: this
              	   },
	                  'onClear' : function(type)	{
	                  		var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME','');
	                  }
					}
				})
			 },{ dataIndex: 'BANK_NAME'	 		,  		width: 160,
	  			editor: Unilite.popup('BANK_G',{
 	 				autoPopup: true,
	  				listeners:{ 'onSelected': {
	                    fn: function(records, type  ){
	                    	var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
							grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
	                    },
	                    scope: this
              	   	},
	                  'onClear' : function(type)	{
	                  		var grdRecord = masterGrid2.uniOpt.currentRecord;
							grdRecord.set('BANK_CODE','');
							grdRecord.set('BANK_NAME','');
	                  }
					}
				})
	  		},
	  		{ dataIndex: 'BANKBOOK_NUM_EXPOS' ,		width: 160, align:'center'},		  		
	  		{ dataIndex: 'BANKBOOK_NUM'	 	  ,  		width: 120,     hidden: true},
	  		{ dataIndex: 'BANKBOOK_NAME'	 	,  		width: 120},
	  		{ dataIndex: 'MAIN_BOOK_YN'       ,       width: 100, align:'center'}
	  		
		],
		
		listeners: {          	
			beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['BOOK_CODE'])){
    				if(e.record.phantom){
    				    return true;
    				}else{
    				    return false;
    				}
				}else if(e.field == "BANKBOOK_NUM_EXPOS")	{
					//e.grid.openCryptPopup( e.record );
					return false;
				}
			},
			onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="BANKBOOK_NUM_EXPOS") {
					grid.ownerGrid.openCryptBankAccntPopup(record);
				}
			}
			
			
			/*,
			cellkeydown:function( view, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
    			if(e.getKey() == 13)	{
    				UniAppManager.app.enterNavigation(e);
    			}
    			
    		}*/
		},
		openCryptBankAccntPopup:function( record )	{
			if(record)	{
				var params = {'BANK_ACCOUNT': record.get('BANKBOOK_NUM'), 'GUBUN_FLAG': '2', 'INPUT_YN': 'Y'};				
				Unilite.popupCipherComm('grid', record, 'BANKBOOK_NUM_EXPOS', 'BANKBOOK_NUM', params);
			}
		}         
	});
    var masterGrid3 = Unilite.createGrid('bcm105ukrvGrid3', {       
        store   : directMasterStore3,
        border  : true,
        height  : 150,
        width   : 912,
        sortableColumns : false,
        
        excelTitle: '전자문서정보',
        uniOpt:{
             expandLastColumn   : true,
             useRowNumberer     : true,
             useMultipleSorting : false,
			 enterKeyCreateRow	: false	
        },
        dockedItems : [{            
            xtype   : 'toolbar',
            dock    : 'top',
            items   : [{
                xtype   : 'uniBaseButton',
                text    : '조회',
                tooltip : '조회',
                iconCls : 'icon-query', 
                width   : 26,
                height  : 26,
                itemId  : 'sub_query3',
                handler: function() { 
                    //if( me._needSave()) {
                    var toolbar = masterGrid3.getDockedItems('toolbar[dock="top"]');
                    var needSave = !toolbar[0].getComponent('sub_save3').isDisabled();
                    var record = masterGrid.getSelectedRecord();
                    if(needSave) {
                        Ext.Msg.show({
                             title:'확인',
                             msg: Msg.sMB017 + "\n" + Msg.sMB061,
                             buttons: Ext.Msg.YESNOCANCEL,
                             icon: Ext.Msg.QUESTION,
                             fn: function(res) {
                                //console.log(res);
                                if (res === 'yes' ) {
                                    var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
                                        directMasterStore3.saveStore();
                                    });
                                    saveTask.delay(500);
                                } else if(res === 'no') {
                                    directMasterStore3.loadStoreRecords(record.get('CUSTOM_CODE'));
                                }
                             }
                        });
                    } else {
                        directMasterStore3.loadStoreRecords(record.get('CUSTOM_CODE'));
                    }
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '신규',
                tooltip : '초기화',
                iconCls : 'icon-reset',
                width   : 26,
                height  : 26,
                itemId  : 'sub_reset3',
                handler : function() { 
                    var toolbar = masterGrid3.getDockedItems('toolbar[dock="top"]');
                    var needSave = !toolbar[0].getComponent('sub_save3').isDisabled();
                    if(needSave) {
                        Ext.Msg.show({
                             title:'확인',
                             msg: Msg.sMB017 + "\n" + Msg.sMB061,
                             buttons: Ext.Msg.YESNOCANCEL,
                             icon: Ext.Msg.QUESTION,
                             fn: function(res) {
                                console.log(res);
                                if (res === 'yes' ) {
                                    var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
                                        directMasterStore3.saveStore();
                                    });
                                    saveTask.delay(500);
                                } else if(res === 'no') {
                                    masterGrid3.reset();
                                    directMasterStore3.clearData();
                                    directMasterStore3.setToolbarButtons('sub_save3', false);
                                    directMasterStore3.setToolbarButtons('sub_delete3', false);
                                }
                             }
                        });
                    } else {
                        masterGrid3.reset();
                        directMasterStore3.clearData();
                        directMasterStore3.setToolbarButtons('sub_save3', false);
                        directMasterStore3.setToolbarButtons('sub_delete3', false);
                    }                   
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '추가',
                tooltip : '추가',
                iconCls : 'icon-new',
                width   : 26,
                height  : 26,
                itemId  : 'sub_newData3',
                handler : function() { 
                    //var record = masterGrid.getSelectedRecord();

                    var compCode    = UserInfo.compCode;  
                    var customCode  = detailForm.getValue('CUSTOM_CODE');
                    if(!Ext.isEmpty(customCode))	{
	                    var seq = directMasterStore3.max('SEQ');
	                    if(!seq){
	                        seq = 1;
	                    }else{
	                        seq += 1;
	                    }
	                    var r = {
	                        COMP_CODE:          compCode,
	                        CUSTOM_CODE:        customCode,
	                        SEQ:                seq
	                    };
	                    masterGrid3.createRow(r);
                    }else {
                    	Unilite.messageBox("거래처 코드를 입력하세요.")
                    }
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '삭제',
                tooltip : '삭제',
                iconCls : 'icon-delete',
                disabled: true,
                width   : 26, 
                height  : 26,
                itemId  : 'sub_delete3',
                handler : function() { 
                    var selRow = masterGrid3.getSelectedRecord();
                    if(selRow.phantom === true) {
                        masterGrid3.deleteSelectedRow();
                    }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                        masterGrid3.deleteSelectedRow();                        
                    }   
                }               
            },{
                xtype   : 'uniBaseButton',
                text    : '저장', 
                tooltip : '저장', 
                iconCls : 'icon-save',
                disabled: true,
                width   : 26,
                height  : 26,
                itemId  : 'sub_save3',
                handler : function() {
                    var inValidRecs = directMasterStore3.getInvalidRecords();           
                    if(inValidRecs.length == 0 )    {
                        var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
                            directMasterStore3.saveStore();
                        });
                        saveTask.delay(500);
                    } else {
                        masterGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
                    }                  
                }
            }]
        }],

        columns:  [
            { dataIndex: 'COMP_CODE'              ,       width: 80,hidden:true},
            { dataIndex: 'CUSTOM_CODE'            ,       width: 80,hidden:true},
            { dataIndex: 'SEQ'                    ,       width: 55},
            { dataIndex: 'PRSN_NAME'              ,       width: 80},
            { dataIndex: 'DEPT_NAME'              ,       width: 100},
            { dataIndex: 'HAND_PHON'              ,       width: 100},
            { dataIndex: 'TELEPHONE_NUM1'         ,       width: 100},
            { dataIndex: 'TELEPHONE_NUM2'         ,       width: 100},
            { dataIndex: 'FAX_NUM'                ,       width: 100},
            { dataIndex: 'MAIL_ID'                ,       width: 140},
            { dataIndex: 'BILL_TYPE'              ,       width: 100},
            { dataIndex: 'MAIN_BILL_YN'           ,       width: 140},
            { dataIndex: 'REMARK'                 ,       width: 100}
        ],
        
        listeners: {            
            beforeedit  : function( editor, e, eOpts ) {
            }
        }          
    });
    /**
     * 상세 조회(Detail Form Panel)
     * @type 
     */
    var detailForm = Unilite.createForm('detailForm', {
//      region:'south',
//    	weight:-100,
//    	height:400,
//    	split:true,
    	hidden: true,
    	masterGrid: masterGrid,
        autoScroll:true,
        border: false,
        padding: '0 0 0 1',       
        uniOpt:{
        	store : directMasterStore
        },
        api: {
			 submit: 'bcm105ukrvService.saveAll'	
		},
	    //for Form      
	    layout: {
	    	type: 'uniTable',
	    	columns: 1,
	    	tableAttrs:{cellpadding:5},
	    	tdAttrs: {valign:'top'}
	    },
	    defaultType: 'fieldset',
	    masterGrid: masterGrid,
	    defineEvent: function(){
	    	var me = this;	        
	        me.getField('CUSTOM_NAME').on ('blur', function( field, blurEvent, eOpts )	{
				//var frm = Ext.getCmp('detailForm');
				if(me.getValue('CUSTOM_FULL_NAME') == "")	
					me.setValue('CUSTOM_FULL_NAME',this.getValue());
			} );
		},
	    items : [{
	    	title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
        	defaultType: 'uniTextfield',
        	flex : 1,
        	layout: {
	            type: 'uniTable',
	            tableAttrs: { style: { width: '100%' } }, 
	            columns: 3
			},    
			items :[{
				fieldLabel: 'Flag',
				name: 'Flag' ,
				hidden:true
			},{
				fieldLabel: '코드',
				id: 'CUSTOM_CODE_READONLY',
				name: 'CUSTOM_CODE',
				maxLength : 10,
				enforceMaxLength: true,
				readOnly: true
				//,
				//allowBlank: false,
				//readOnly:true
			},{
				fieldLabel: '법인/개인', 
				name: 'BUSINESS_TYPE', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B016'
			},{
				fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>',
				name: 'CUSTOM_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B015' ,
				allowBlank: false,
				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {     
//                    	var record = masterGrid.getSelectedRecord()
//                    	if(record.phantom){
                    	   if(newValue == "4"){    //구분 금융일시 거래처코드는 입력OR자동채번 해서 저장.. 그외 자동채번
                                detailForm.getField("CUSTOM_CODE").setReadOnly(false);
                            }else{
                            	detailForm.setValue('CUSTOM_CODE', '');
                                detailForm.getField("CUSTOM_CODE").setReadOnly(true);                        
                            }                    	
//                    	} 
                    }
                }
			},{
				fieldLabel: '거래처(약명)',
				name: 'CUSTOM_NAME'  ,
				allowBlank: false,
				listenersX:{blur : function(){
					var frm = Ext.getCmp('detailForm');
					if(frm.getValue('CUSTOM_FULL_NAME') == "")	
					frm.setValue('CUSTOM_FULL_NAME',this.getValue());
				}}
			},{
				fieldLabel: '사업자번호',
				name: 'COMPANY_NUM',
				/*listeners:{
					change: function(combo, newValue, oldValue, eOpts) { 
                        var frm = Ext.getCmp('detailForm');  
                	    if(isNaN(newValue)){
                            Unilite.messageBox('숫자만 입력가능합니다.');
                            frm.setValue('COMPANY_NUM','');
                        }	
					}
				}*/
				maxLength: 12 /*,
                allowBlank: false */
			},{
				fieldLabel: '업태',
				name: 'COMP_TYPE'
			},{
				fieldLabel: '거래처(약명1)',
				name: 'CUSTOM_NAME1' 
			},{
                fieldLabel: '종사업자번호',
                name: 'SERVANT_COMPANY_NUM',
                maxLength: 8
            },{
				fieldLabel: '업종',
				name: 'COMP_CLASS'
			},{
				fieldLabel: '거래처(약명2)', 
				name: 'CUSTOM_NAME2' 
			},{
                fieldLabel: '대표자명',
                name: 'TOP_NAME'
            },{
				fieldLabel: '주민번호', 
				name: 'TOP_NUM',
				hidden: true
			},{
				fieldLabel: '고객분류',
				name: 'AGENT_TYPE',
				xtype : 'uniCombobox',
				allowBlank: false,
				comboType:'AU',
				comboCode:'B055'
			},{
				fieldLabel: '거래처명(전명)', 
				name: 'CUSTOM_FULL_NAME',
				allowBlank: false
			},{ 
                fieldLabel:'주민등록번호',
                name :'TOP_NUM_EXPOS',
                xtype: 'uniTextfield',
                readOnly:true,
                focusable:false,
                maxLength: 14,
                value	: '**************',
                listeners:{
                    afterrender:function(field) {
                        field.getEl().on('dblclick', field.onDblclick);
                    }/*,
                    change: function(combo, newValue, oldValue, eOpts) { 
                        var frm = Ext.getCmp('detailForm');  
                        if(isNaN(newValue)){
                            Unilite.messageBox('숫자만 입력가능합니다.');
                            frm.setValue('TOP_NUM_EXPOS','');
                        }   
                    }*/
                },
                onDblclick:function(event, elm) {                   
                    detailForm.openCryptRepreNoPopup();
                }
            },{
				fieldLabel: '지역',
				name: 'AREA_TYPE',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B056'
			},{
				fieldLabel: '거래시작일',
				name: 'START_DATE' ,
				xtype : 'uniDatefield', 
				allowBlank:false
			},{
				fieldLabel: '거래중단일',  
				name: 'STOP_DATE',
				xtype : 'uniDatefield'
			},{
				fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>', 
				name: 'USE_YN',
				xtype: 'uniRadiogroup',
				width: 230, 
				comboType:'AU',
				comboCode:'B010', 
				value:'Y' ,
				allowBlank: false
			},{
				fieldLabel: '사업자번호변경여부',
				name: 'CUST_CHK',
				hidden:true
			},{
				fieldLabel: '주민번호변경여부',  
				name: 'SSN_CHK', hidden:true
			}]
	    },{   
	    	title: '업무정보',
        	//,collapsible: true
        	defaultType: 'uniTextfield',
        	flex : 1,
			layout: {
	            type: 'uniTable',
	            tableAttrs: { style: { width: '100%' } }, 
	            columns: 3
			},
			 
			items :[{
				fieldLabel: '국가코드',
				name: 'NATION_CODE',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B012'
			},{
				fieldLabel: '계산서종류',
				name: 'BILL_TYPE',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'A022'
			},{
				fieldLabel: '여신(담보)액',
				name: 'TOT_CREDIT_AMT',
				xtype:'uniNumberfield'
			},{
				fieldLabel: '기준화폐',
				name: 'MONEY_UNIT',
				xtype : 'uniCombobox',
				comboType:'AU',
				fieldStyle: 'text-align: center;',
				comboCode:'B004', 
				displayField: 'value'
			},{
				fieldLabel: '결제방법',
				name: 'SET_METH', 
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B038'
			},{
				fieldLabel: '신용여신액',
				name: 'CREDIT_AMT',
				xtype:'uniNumberfield'
			},{
				fieldLabel: '세액포함여부',
				name: 'TAX_TYPE',
				xtype: 'uniRadiogroup', 
				width: 230, 
				comboType:'AU',
				comboCode:'B030',
				value:'1' , 
				allowBlank:false
			},{
				fieldLabel: '결제조건', 
				name: 'RECEIPT_DAY',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B034'
			},{
				fieldLabel: '신용여신만료일',
				name: 'CREDIT_YMD',
				xtype : 'uniDatefield'
			},{
				fieldLabel: '세액계산법',
				name: 'TAX_CALC_TYPE',
				xtype: 'uniRadiogroup',
				width: 230, comboType:'AU',
				comboCode:'B051',
				value:'1',
				allowBlank:false  
			},{
				fieldLabel: '마감종류',
				name: 'TRANS_CLOSE_DAY',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B033'
			},{
				fieldLabel: '미수관리방법',
				name: 'COLLECT_CARE',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B057' 
			},{
				fieldLabel: '원미만계산',
				name: 'WON_CALC_BAS',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B017'
			},{
				fieldLabel: '수금(예정)일',
				name: 'COLLECT_DAY', 
				xtype:'uniNumberfield' 
			},{
				fieldLabel: '주영업담당',
				name: 'BUSI_PRSN', 
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'S010'  
			},{
				fieldLabel: '세율',
				name: 'VAT_RATE',
				minWidth:50, suffixTpl:'&nbsp;%' ,
				xtype:'uniNumberfield'
			},{
				fieldLabel: '여신적용여부',
				name:'CREDIT_YN',
				xtype: 'uniRadiogroup',
				width: 230,
				comboType:'AU',
				comboCode:'B010',
				value:'N',
				allowBlank:false
			},{
				fieldLabel: '카렌더타입',
				name: 'CAL_TYPE',
				xtype : 'uniCombobox',
				comboType:'AU',
				comboCode:'B062'  
			},
				Unilite.popup('DEPT',{
					fieldLabel: '관련부서',
					valueFieldWidth:50,
					textFieldWidth:100,
					textFieldName:'DEPT_NAME',
					valueFieldName:'DEPT_CODE',
					DBvalueFieldName: 'TREE_CODE',
					DBtextFieldName: 'TREE_NAME',
					listeners: {
		                'onSelected': function(records, type  ){
		                    	//var grdRecord = masterGrid.getSelectedRecord();
		                    	//grdRecord.set('DEPT_CODE',records[0]['TREE_CODE']);
		                    	//grdRecord.set('DEPT_NAME',records[0]['TREE_NAME']);
		                },
		                'onClear':  function( type  ){
		                    	//var grdRecord = masterGrid.getSelectedRecord();
		                    	//grdRecord.set('DEPT_NAME','');
		                    	//grdRecord.set('DEPT_CODE','');
		                }
					}
			}),
			 {
			 	fieldLabel: '전자문서담당자2',
			 	//labelWidth:120,
			 	name: 'BILL_PRSN2',
			 	width:245
			 },{
			 	fieldLabel: '전자문서핸드폰2',
			 	//labelWidth:120,
			 	name: 'HAND_PHON2',
			 	width:245
			 },{
			 	fieldLabel: '전자문서Email2',
			 	//labelWidth:120,
			 	name: 'BILL_MAIL_ID2',
			 	width:245
			 },{
			 	fieldLabel: '전자문서구분',
			 	//labelWidth:120,
			 	name: 'BILL_MEM_TYPE',
			 	xtype : 'uniCombobox',
			 	comboType:'AU',
			 	comboCode:'S051', 
			 	width:245
			 },{
                fieldLabel: '정기결제여부',
                name:'R_PAYMENT_YN',
                xtype: 'uniRadiogroup',
                width: 230,
                comboType:'AU',
                comboCode:'B010',
                value:'N',
                allowBlank:false
            },{
                xtype: 'component'
            },{
                xtype: 'component'
            },{
                fieldLabel: '운송방법',
                //labelWidth:120,
                name: 'DELIVERY_METH',
                xtype : 'uniCombobox',
                comboType:'AU',
                comboCode:'S051', 
                width:245,
                colspan:2
             }]
		},{  
			title: '<t:message code="system.label.base.generalinfo" default="일반정보"/>',
			flex : 1,
			defaultType: 'uniTextfield',
			layout: {
			            type: 'uniTable',
			            tableAttrs: { style: { width: '100%' } },
			            tdAttrs:{valign:'top'},
			            columns: 3
			},
			items :[
				Unilite.popup('ZIP',{
					showValue:false,
					textFieldName:'ZIP_CODE',
					DBtextFieldName:'ZIP_CODE',
					listeners: { 'onSelected': {
					                    fn: function(records, type  ){
					                    	var frm = Ext.getCmp('detailForm');
					                    	frm.setValue('ADDR1', records[0]['ZIP_NAME']);
					                    	frm.setValue('ADDR2', records[0]['ADDR2']);
					                    	//console.log("(records[0]['ZIP_CODE1_NAME'] : ", records[0]['ZIP_CODE1_NAME']);
					                    	//Ext.getCmp('ADDR2_F').setValue(records[0]['ADDR2']);
					                    },
					                    scope: this
					                  },
					                  'onClear' : function(type)	{
					                  		var frm = Ext.getCmp('detailForm');
					                    	frm.setValue('ADDR1', '');
					                    	frm.setValue('ADDR2', '');
					                  }
					}
			}),
												
				{fieldLabel: '홈페이지',
				name: 'HTTP_ADDR'
			},
				Unilite.popup('CUST',{
					fieldLabel: '집계거래처', /* id:'MANAGE_CUSTOM', */
					valueFieldName:'MANAGE_CUSTOM',
					textFieldName:'MCUSTOM_NAME',
				    DBvalueFieldName:'CUSTOM_CODE',
				    DBtextFieldName:'CUSTOM_NAME',				  
					listeners: {
		                'onSelected': function(records, type  ){
		                    	//var grdRecord = masterGrid.getSelectedRecord();
		                    	//grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
		                    	//grdRecord.set('MCUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                },
		                'onClear':  function( type  ){
		                    	//var grdRecord = masterGrid.getSelectedRecord();
		                    	//grdRecord.set('MANAGE_CUSTOM','');
		                    	//grdRecord.set('MCUSTOM_NAME','');
		                }
					}
		  	}),						            
			  {
			  	fieldLabel: '우편주소', 
			  	name: 'ADDR1' , 
			  	id :'ADDR1_F'
			},{
				fieldLabel: 'E-mail',
				name: 'MAIL_ID'
			},
				Unilite.popup('CUST',{
					fieldLabel: '수금거래처', 
					valueFieldName:'COLLECTOR_CP',
					textFieldName:'COLLECTOR_CP_NAME',
					DBvalueFieldName:'CUSTOM_CODE',
					DBtextFieldName:'CUSTOM_NAME',
					listeners: {
		                'onSelected': function(records, type  ){
		                    	//var grdRecord = masterGrid.getSelectedRecord();
		                    	//grdRecord.set('COLLECTOR_CP',records[0]['CUSTOM_CODE']);
		                    	//grdRecord.set('COLLECTOR_CP_NAME',records[0]['CUSTOM_NAME']);
		                },
		                'onClear':  function( type  ){
		                    	var grdRecord = masterGrid.getSelectedRecord();
		                    	//grdRecord.set('COLLECTOR_CP','');
		                    	//grdRecord.set('COLLECTOR_CP_NAME','');
		                }
					}
			}),
				{
				fieldLabel: '상세주소',
				name: 'ADDR2',
				id:'ADDR2_F'
			},
				Unilite.popup('BANK',{
					fieldLabel: '금융기관',
					id:'BANK_CODE',
					valueFieldName:'BANK_CODE',
					textFieldName:'BANK_NAME' ,
					DBvalueFieldName:'BANK_CODE',
					DBtextFieldName:'BANK_NAME',
					listeners: {
		                'onSelected': function(records, type  ){
		                    	//var grdRecord = masterGrid.getSelectedRecord();
		                    	//grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
		                    	//grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
		                },
		                'onClear':  function( type  ){
		                    	var grdRecord = masterGrid.getSelectedRecord();
		                    	grdRecord.set('BANK_CODE','');
		                    	grdRecord.set('BANK_NAME','');
		                }
					}
			}),
				Unilite.popup('CUST',{
					fieldLabel: '계산서거래처',
					id:'BILL_CUSTOM',
					valueFieldName:'BILL_CUSTOM',
					textFieldName:'BILL_CUSTOM_NAME' ,
					DBvalueFieldName:'CUSTOM_CODE', 
					DBtextFieldName:'CUSTOM_NAME',
					listeners: {
		                'onSelected': function(records, type  ){
		                    	//var grdRecord = masterGrid.getSelectedRecord();
		                    	//grdRecord.set('BILL_CUSTOM',records[0]['CUSTOM_CODE']);
		                    	//grdRecord.set('BILL_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                },
		                'onClear':  function( type  ){
		                    	//var grdRecord = masterGrid.getSelectedRecord();
		                    	//grdRecord.set('BILL_CUSTOM','');
		                    	//grdRecord.set('BILL_CUSTOM_NAME','');
		                }
					}
			}),
				{
				fieldLabel: '전화번호',
				name: 'TELEPHON'
			},{
                fieldLabel: 'FAX번호',
                name: 'FAX_NUM',
                colspan:2
            },{
				fieldLabel: '계좌번호', 
				name: 'BANKBOOK_NUM',
				hidden:false
			},
//				{
//				fieldLabel: '전자세금계산서발행여부',
//				name:'BILL_PUBLISH_TYPE',
//				xtype: 'uniRadiogroup',
//				width: 230,
//				comboType:'AU',
//				comboCode:'B010',
//				value:'1',
//				allowBlank:false
//			},
			{
				fieldLabel: '예금주',
				name: 'BANKBOOK_NAME',
				colspan:2,
				hidden:false
			},{
				fieldLabel: '<t:message code="system.label.base.remarks" default="비고"/>', 
				name: 'REMARK',
				xtype:'textarea',
				width:740,
				height:80,
				colspan:3
			}]
	    }],
		listeners:{
			uniOnChange:function( basicForm, dirty, eOpts ) {
					console.log("onDirtyChange");
					if(basicForm.isDirty())	{
						UniAppManager.setToolbarButtons('save', true);
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
				},
				beforeaction:function(basicForm, action, eOpts)	{
					
					if(action.type =='directsubmit')	{
						var invalid = detailForm.getForm().getFields().filterBy(function(field) {
						            return !field.validate();
						    });
				        	
			         	if(invalid.length > 0)	{
				        	r=false;
				        	var labelText = ''
				        	
				        	if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
				        		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				        	}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
				        		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				        	}
				        	Unilite.messageBox(labelText+Msg.sMB083);
				        	invalid.items[0].focus();
				        }																									
					}
				},
			hide:function()	{
				masterGrid.show();
				UniAppManager.setToolbarButtons('delete',false);	
				if(panelSearch.getCollapsed()){		//panelSearch가 닫혀 있으면..
					panelResult.show();
				}
			}

		},
   		openCryptRepreNoPopup:function(  )	{
		var record = this;
						
		var params = {'REPRE_NO':this.getValue('TOP_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'};
		Unilite.popupCipherComm('form', record, 'TOP_NUM_EXPOS', 'TOP_NUM', params);				
		}

	}); // detailForm
	
	
    var detailComponent = Unilite.createForm('detailComponent', {
    	hidden: true,
        autoScroll:true,
        border: false,
        disabled :false,
        padding: '0 0 0 1',       
        uniOpt:{
        	store : directMasterStore
        },
	    //for Form      
	    layout: {
	    	type: 'uniTable',
	    	columns: 1,
	    	tableAttrs:{cellpadding:5},
	    	tdAttrs: {valign:'top'}
	    },
	    defaultType: 'fieldset',
		xtype:'',
		items:[
			{  
			title	: '계좌정보',
			layout	: {
	            type		: 'uniTable',
	            tdAttrs		: {valign:'top'},
	            columns		: 3
			},
			items : [masterGrid2]
	    },{  
            title   : '전자문서정보',
            layout  : {
                type        : 'uniTable',
                tdAttrs     : {valign:'top'},
                columns     : 3
            },
            items : [masterGrid3]
        }
		]
		
		
	})
	
	
    Unilite.Main({
    	id  : 'bcm105ukrvApp',
		borderItems : [
			panelSearch,
			panelResult,
			{	region:'center',
				//layout : 'border',
				title:'거래처정보',
				layout : {type:'vbox', align:'stretch'},
				flex:1,
				autoScroll:true,
				tools: [
					{
						type: 'hum-grid',					            
			            handler: function () {
			            	if(UniAppManager.app._needSave())	{
			            		UniAppManager.app.confirmSaveData();
			            		
			            	} else {
			            		detailForm.hide();
			            		detailComponent.hide();
			            	}
			                //masterGrid.show();
			            	//panelResult.show();
			            }
					},{
			
						type: 'hum-photo',					            
			            handler: function () {
			            	/*
			            	var edit = masterGrid.findPlugin('cellediting');
							if(edit && edit.editing)	{
								setTimeout("edit.completeEdit()", 1000);
							}
							*/
			            	if(masterGrid.getSelectedRecords().length == 0)	{
			            		Unilite.messageBox("조회할 데이타를 선택하세요.");
			            	}else {
			            		//detailForm.setValue("Flag","U");
				                masterGrid.hide();
				                panelResult.hide();
				                //detailForm.show();
			            	}
			            }
					}
				],
				items:[					
					masterGrid, 
					detailForm,
					detailComponent
				]
			}
		],		
		autoButtonControl : false,
		fnInitBinding : function(params) {
			if(BsaCodeInfo.gsHiddenField == 'Y'){
                detailForm.getField('BANKBOOK_NUM').setHidden(true);
                detailForm.getField('BANKBOOK_NAME').setHidden(true);
            }else{
                detailForm.getField('BANKBOOK_NUM').setHidden(false);
                detailForm.getField('BANKBOOK_NAME').setHidden(false);
            }
			if(params && params.CUSTOM_CODE ) {
				panelSearch.setValue('CUSTOM_CODE',params.CUSTOM_CODE);
				panelSearch.setValue('COMP_CODE',params.COMP_CODE);
				masterGrid.getStore().loadStoreRecords();
			}
			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);	
			
			detailForm.getField("CUSTOM_CODE").setReadOnly(true);
			detailForm.hide();
			detailComponent.hide();
			masterGrid.show();
			
		},
		
		
		onQueryButtonDown : function()	{
			delfag = '';
//			detailForm.clearForm ();
			detailForm.hide();
			detailComponent.hide();
			            		
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown : function()	{
			delfag = 'N';
			
			masterGrid.hide();
			detailForm.setDisabled(false);			
			detailForm.clearForm();
//			detailForm.getField("CUSTOM_CODE").setReadOnly(false);
			detailForm.setValue("Flag", "");
			detailForm.setReadOnly(false);	
			detailForm.getField("CUSTOM_CODE").setReadOnly(true);
			detailForm.getField("TOP_NUM_EXPOS").setReadOnly(true);
			
			masterGrid2.reset();
			directMasterStore2.setToolbarButtons(['sub_save3'], false);
            masterGrid3.reset();
            directMasterStore3.setToolbarButtons(['sub_save3'], false);

		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},		
		onSaveDataButtonDown: function (config) {
			//directMasterStore.saveStore(config);
			if(detailForm.getValue('BUSINESS_TYPE') == "3" || detailForm.getValue('CUSTOM_TYPE') == "4" ){
                detailForm.getField('COMPANY_NUM').allowBlank = true;				
			}else{
			    detailForm.getField('COMPANY_NUM').allowBlank = false;
			}
			
			var param= detailForm.getValues();
			if(detailForm.isValid())	{
			Ext.getBody().mask('로딩중...','loading-indicator');
				if (delfag == 'N') {
					var countParam = detailForm.getValues();
					
				} else {
					var countParam = {"USE_YN": 'NOT USE'};
				}
				//countParam 생성 후, 초기화
				delfag == '';
				
				bcm105ukrvService.getCount(countParam, function(provider, response)	{
					if(!Ext.isEmpty(provider)){ 
						if(!Ext.isEmpty(provider.COM_CNT) && provider.COM_CNT != 0) {
							Unilite.messageBox("동일한 사업자번호가 등록되어 있습니다.");
							return false;
						}
						if(!Ext.isEmpty(provider.TOP_CNT) && provider.TOP_CNT != 0) {
							Unilite.messageBox("동일한 주민등록 번호가 등록되어 있습니다.");
							return false;
						}
					}
					
					detailForm.getForm().submit({
						 params : param,
						 success : function(form, action) {
					 		Ext.getBody().unmask();
					 		
					 		if(detailForm.getValue("Flag") == "D")	{
								detailForm.clearForm();
	//							detailForm.getField("CUSTOM_CODE").setReadOnly(false);
								detailForm.setValue("Flag", "");
								detailForm.setReadOnly(false);	
								masterGrid2.reset();
								directMasterStore2.setToolbarButtons(['sub_save3'], false);
					            masterGrid3.reset();
					            directMasterStore3.setToolbarButtons(['sub_save3'], false);
					 		}else {
					 			detailForm.setValue("Flag","U");
					 			detailForm.uniOpt.inLoading=true;
					 			detailForm.setValue("CUSTOM_CODE",action.result.CUSTOM_CODE);
					 			detailForm.uniOpt.inLoading=false;
					 			
						 		panelSearch.setValue("CUSTOM_CODE",detailForm.getValue("CUSTOM_CODE"));
						 		panelResult.setValue("CUSTOM_CODE",detailForm.getValue("CUSTOM_CODE"));
						 		panelSearch.setValue("CUSTOM_NAME",detailForm.getValue("CUSTOM_NAME"));
						 		panelResult.setValue("CUSTOM_NAME",detailForm.getValue("CUSTOM_NAME"));
					 		}
		 					detailForm.getForm().wasDirty = false;
							detailForm.resetDirtyStatus();	
							UniAppManager.setToolbarButtons('save', false);	
		            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
		            		//directMasterStore.loadStoreRecords(param);
						 }	
					});
				});	
			}else {
				var invalid = detailForm.getForm().getFields().filterBy(function(field) {
						            return !field.validate();
				    });
		        	
	         	if(invalid.length > 0)	{
		        	r=false;
		        	var labelText = ''
		        	
		        	if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
		        		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
		        		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
		        	Unilite.messageBox(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		        }			
			}
			
	 		Ext.getBody().unmask();				
		},
		onDeleteDataButtonDown : function()	{
			delfag = '';
			
			if(confirm('삭제 하시겠습니까?')) {
				detailForm.setValue("Flag", "D");
				detailForm.setReadOnly(true);
				
				//masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown:function() {
			delfag = '';
			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().addProxyParams(null, {'Init':'true'});
			masterGrid.getStore().removeAll();
			detailForm.clearForm();
//			detailForm.getField("CUSTOM_CODE").setReadOnly(false);
			detailForm.setValue("Flag", "");
			detailForm.setReadOnly(false);
			masterGrid2.reset();
			directMasterStore2.setToolbarButtons(['sub_save3'], false);
            masterGrid3.reset();
            directMasterStore3.setToolbarButtons(['sub_save3'], false);
			UniAppManager.setToolbarButtons('save',false);	
			this.fnInitBinding();
//			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		rejectSave: function()	{
			detailForm.clearForm();
//			detailForm.getField("CUSTOM_CODE").setReadOnly(false);
			detailForm.setValue("Flag", "");
			detailForm.setReadOnly(false);
			masterGrid2.reset();
			directMasterStore2.setToolbarButtons(['sub_save3'], false);
            masterGrid3.reset();
            directMasterStore3.setToolbarButtons(['sub_save3'], false);
			UniAppManager.setToolbarButtons('save',false);	
			if(detailForm.isVisible())	{
				detailForm.hide();
				detailComponent.hide();
			}
		}, 	
		confirmSaveData: function()	{
        	if(detailForm.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown();
				} else {
					this.rejectSave();
					masterGrid.show();
				}
			}else {
				UniAppManager.setToolbarButtons('save',false);	
			}
			
        },
       enterNavigation: function (keyEvent)	{
	   		var position = keyEvent.position,
	            view = position.view;
	        
	   		if(keyEvent.keyCode ==13 && view.store.uniOpt.editable && keyEvent.position.isLastColumn() && !keyEvent.position.column.isLocked() && view.ownerGrid.uniOpt.enterKeyCreateRow)	{
	   			UniAppManager.app.onNewDataButtonDown();
	   			return;
	   		}else {
	   		
		        var newPosition = view.move('right', keyEvent);
		
		        if (newPosition) {
		            view.setPosition(newPosition, null, keyEvent);
		        }
	   		}
	    }
	});	// Main
	
	Unilite.createValidator('validator01', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, ePanel, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(fieldName=='CUSTOM_CODE')	{
				Ext.getBody().mask();
				if(newValue != oldValue)	{
					var param = {
						'CUSTOM_CODE':newValue
					}
					var currentRecord = record;
					bcm100ukrvService.chkPK(param, function(provider, response)	{
						Ext.getBody().unmask();
						console.log('provider', provider);
						if(!Ext.isEmpty(provider) && provider['CNT'] > 0){
							return Msg.fSbMsgZ0049;
						}else {
//							detailForm.getField("CUSTOM_CODE").setReadOnly(true);
						}
					});
				}
			} else if( fieldName == 'CUSTOM_NAME' ) {		// 거래처(약명)
				if(newValue == '')	{
					rv = Msg.sMB083;
				}else {
					if(detailForm.getField('CUSTOM_FULL_NAME'))	{
					 	detailForm.setValue('CUSTOM_FULL_NAME',newValue);		
					}
				}
			} else if( fieldName == 'COMPANY_NUM') { 		// '사업자번호'
				 
				 if ( (newValue != oldValue) && ( newValue.trim().length > 0 ) )	{
				 	if(Unilite.validate('bizno', newValue) != true)	{
				 		if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{
				 			rv = false;
				 		}
				 	}else {
				 		newValue = newValue.replace(/-/g,'');
				 		var v = newValue.substring(0,3)+ "-"+ newValue.substring(3,5)+"-" + newValue.substring(5,10);
				 		if(type == 'grid') {
							e.cancel=true;
							detailForm.setValue(fieldName, v);
						}else {
							editor.setValue(v);
						}
						detailForm.setValue('CUST_CHK','T');
				 	}
				 }
			} /*else if( fieldName == 'TOP_NUM') { 		// '주민번호'
				 if ( (newValue != oldValue) && ( newValue.trim().length > 0 ) )	{
				 	if(Unilite.validate('residentno', newValue) != true)	{
				 		if(!confirm(Msg.sMB174+"\n"+Msg.sMB176))	{
				 			rv = false;
				 		}
				 	}else {
				 		newValue = newValue.replace(/-/g,'');
				 		var v = newValue.substring(0,6)+ "-"+ newValue.substring(6,13);
				 		if(type == 'grid') {
							e.cancel=true;
							detailForm.setValue(fieldName, v);
						}else {
							editor.setValue(v);
						}
				 	}
				 }
			} */else if( fieldName ==  "MONEY_UNIT") { 			// 기준화폐
				if(UserInfo.currency == newValue) {
					detailForm.setValue('CREDIT_YN', 'Y');
				}else {
					detailForm.setValue('CREDIT_YN', 'N');
				}
			} else if( fieldName ==  "CREDIT_YN" ) {			// 여신적용여부
				if(UserInfo.currency != record.get("MONEY_UNIT")) {
					console.log('GRID CREDIT_YN BLUR');
					if("Y" == newValue ) 	{
						detailForm.setValue('CREDIT_YN','N');
						rv = Msg.sMB217;
					}
				}
			} else if( fieldName == "VAT_RATE" ) { 			// 세율
				if(newValue < 0 ) {
					rv = Msg.sMB076;
				}
			} else if( fieldName ==  "TOT_CREDIT_AMT") {		// 여신(담보)액
				if(newValue < 0 ) {
					rv = Msg.sMB076;
				}
			} else if( fieldName == "COLLECT_DAY") {
				if(newValue < 1 || newValue > 31 ) {
					rv = Msg.sMB210;
				}
			}
				
			return rv;
		}
	}); // validator
	
	
}; // main


</script>


