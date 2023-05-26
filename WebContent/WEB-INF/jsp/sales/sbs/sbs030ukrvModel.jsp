<%@page language="java" contentType="text/html; charset=utf-8"%>
	/**
	 *   Model 정의 
	 * @type 
	 */	
	//sbs030ukrvs0_1 Model
	Unilite.defineModel('sbs030ukrvs0_1Model', {
	    fields: [{name: 'ITEM_CODE'			,text:'<t:message code="system.label.sales.item" default="품목"/>'		,type: 'string'},
			 	 {name: 'ITEM_NAME'			,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'},
			 	 {name: 'SPEC'		 		,text:'<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},
			 	 {name: 'STOCK_UNIT'		,text:'<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'		,type: 'string', displayField: 'value'},
			 	 {name: 'SALE_UNIT'	 		,text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'		,type: 'string', displayField: 'value'},
			 	 {name: 'BASIS_P'			,text:'<t:message code="system.label.sales.sellingprice" default="판매단가"/>'		,type: 'uniUnitPrice'},
			 	 {name: 'DOM_FORIGN'		,text:'내외자구분'		,type: 'string'},
			 	 {name: 'ITEM_ACCOUNT'		,text:'<t:message code="system.label.sales.itemaccount" default="품목계정"/>'		,type: 'string'},
			 	 {name: 'TRNS_RATE'	  		,text:'<t:message code="system.label.sales.containedqty" default="입수"/>'			,type: 'uniQty'}			 	 
			]
	});
	//sbs030ukrvs0_1 store
	var sbs030ukrvs0_1Store = Unilite.createStore('sbs030ukrvs0_1Store',{
			model: 'sbs030ukrvs0_1Model',
            //autoLoad: true,
            uniOpt : {
            	isMaster: true,			    // 상위 버튼 연결 
            	editable: true,			    // 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			    // prev | next 버튼 사용
            },
            proxy: directProxy0_1,
            loadStoreRecords : function(){
                var param =  panelDetail.down('#tab_sbs030ukrv0Tab').getValues();
                this.load({
                    params: param
                });
            }   
	});
		//sbs030ukrvs0_2 Model
	Unilite.defineModel('sbs030ukrvs0_2Model', {
	    fields: [{name: 'TYPE'					,text:'타입'			,type: 'string'},			 	 
				 {name: 'ITEM_CODE'				,text:'<t:message code="system.label.sales.item" default="품목"/>'		,type: 'string'},			 	 
				 {name: 'CUSTOM_CODE'			,text:'<t:message code="system.label.sales.client" default="고객"/>'		,type: 'string', allowBlank: false, maxLength: 8},			 	 
				 {name: 'CUSTOM_NAME'			,text:'<t:message code="system.label.sales.clientname" default="고객명"/>'		    ,type: 'string', maxLength: 20},			 	 
				 {name: 'MONEY_UNIT'			,text:'<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'		,type: 'string', allowBlank: false, maxLength: 3, comboType: 'AU', comboCode: 'B004', displayField: 'value' },			 	 
				 {name: 'ORDER_UNIT'			,text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'		,type: 'string', displayField: 'value', allowBlank: false, maxLength: 3, comboType: 'AU', comboCode: 'B013' },			 	 
				 {name: 'ITEM_P'				,text:'<t:message code="system.label.sales.sellingprice" default="판매단가"/>'		,type: 'uniUnitPrice', allowBlank: false, maxLength: 18},			 	 
				 {name: 'APLY_START_DATE'		,text:'적용시작일'		,type: 'uniDate', allowBlank: false, maxLength: 8},			 	 
				 {name: 'DIV_CODE'				,text:'<t:message code="system.label.sales.division" default="사업장"/>'		    ,type: 'string'},			 	 
				 {name: 'UPDATE_DB_USER'		,text:'<t:message code="system.label.sales.updateuser" default="수정자"/>'		    ,type: 'string'},			 	 
				 {name: 'UPDATE_DB_TIME'   		,text:'<t:message code="system.label.sales.updatedate" default="수정일"/>'		    ,type: 'uniDate'},			 	 
				 {name: 'REMARK'				,text:'<t:message code="system.label.sales.remarks" default="비고"/>'			,type: 'string', maxLength: 100},			 	 
				 {name: 'COMP_CODE' 			,text:'COMP_CODE'	    ,type: 'string'}			 	 
				 
	    ]
	});
	//sbs030ukrvs0_2 store
	var sbs030ukrvs0_2Store = Unilite.createStore('sbs030ukrvs0_2Store',{
			model: 'sbs030ukrvs0_2Model',
            //autoLoad: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy0_2,
            loadStoreRecords : function(){
                var param =  panelDetail.down('#tab_sbs030ukrv0Tab').getValues();
                this.load({
                    params: param
                });
            },
            saveStore : function()  {   
                var inValidRecs = this.getInvalidRecords();
                var rv = true;
                if(inValidRecs.length == 0 )    {
                    this.syncAllDirect();
                } else {
                     panelDetail.down('#sbs030ukrv0_Grid2').uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            } 
	});

		//sbs030ukrvs0_3 Model
	Unilite.defineModel('sbs030ukrvs0_3Model', {
	    fields: [{name: 'TYPE'			      ,text:'타입'		        ,type: 'string'},
			 	 {name: 'ITEM_CODE'			  ,text:'<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
                 {name: 'CUSTOM_CODE'         ,text:'<t:message code="system.label.sales.client" default="고객"/>'              ,type: 'string', allowBlank: false, maxLength: 8},
                 {name: 'CUSTOM_NAME'         ,text:'<t:message code="system.label.sales.clientname" default="고객명"/>'            ,type: 'string', maxLength: 20},
                 {name: 'CUSTOM_ITEM_CODE'    ,text:'고객품목'          ,type: 'string', allowBlank: false, maxLength: 20},
                 {name: 'CUSTOM_ITEM_NAME'    ,text:'고객품목명'        ,type: 'string', maxLength: 40},
                 {name: 'CUSTOM_ITEM_SPEC'    ,text:'고객품목규격'      ,type: 'string', maxLength: 40},
                 {name: 'ORDER_UNIT'          ,text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'          ,type: 'string', allowBlank: false, maxLength: 3},
                 {name: 'BASIS_P'             ,text:'<t:message code="system.label.sales.basisprice" default="기준단가"/>'          ,type: 'string', maxLength: 18},
                 {name: 'ORDER_P'             ,text:'<t:message code="system.label.sales.sellingprice" default="판매단가"/>'          ,type: 'uniUnitPrice', maxLength: 18},
                 {name: 'TRNS_RATE'           ,text:'변환계수'          ,type: 'uniER', maxLength: 12},
                 {name: 'AGENT_P'             ,text:'자거래처단가'      ,type: 'uniUnitPrice', maxLength: 18},
                 {name: 'APLY_START_DATE'     ,text:'적용시작일'        ,type: 'uniDate', allowBlank: false, maxLength: 8},
                 {name: 'ORDER_PRSN'          ,text:'구매담당자'        ,type: 'string'},
                 {name: 'MAKER_NAME'          ,text:'메이커명'          ,type: 'string'},
                 {name: 'AGREE_DATE'          ,text:'승인일'            ,type: 'uniDate'},
                 {name: 'ORDER_RATE'          ,text:'발주율'            ,type: 'uniER'},
                 {name: 'REMARK'              ,text:'<t:message code="system.label.sales.remarks" default="비고"/>'              ,type: 'string', maxLength: 100},
                 {name: 'DIV_CODE'            ,text:'<t:message code="system.label.sales.division" default="사업장"/>'            ,type: 'string'},
                 {name: 'UPDATE_DB_USER'      ,text:'<t:message code="system.label.sales.updateuser" default="수정자"/>'            ,type: 'string'},
                 {name: 'UPDATE_DB_TIME'      ,text:'<t:message code="system.label.sales.updatedate" default="수정일"/>'            ,type: 'uniDate'},
                 {name: 'COMP_CODE'           ,text:'<t:message code="system.label.sales.compcode" default="법인코드"/>'          ,type: 'string'}	 	 
			]
	});
	//sbs030ukrvs0_3 store
	var sbs030ukrvs0_3Store = Unilite.createStore('sbs030ukrvs0_3Store',{
			model: 'sbs030ukrvs0_3Model',
            //autoLoad: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy0_3,
            loadStoreRecords : function(){
                var param =  panelDetail.down('#tab_sbs030ukrv0_1Tab').getValues();
                this.load({
                    params: param
                });
            },
            saveStore : function()  {   
                var inValidRecs = this.getInvalidRecords();
                var rv = true;
                if(inValidRecs.length == 0 )    {
                    this.syncAllDirect();
                } else {
                     panelDetail.down('#sbs030ukrv0_Grid3').uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }   
	});

//	//sbs030ukrvs1 Model
//	Unilite.defineModel('sbs030ukrvs1Model', {
//	    fields: [{name: 'ITEM_CODE'	 		,text:'<t:message code="system.label.sales.item" default="품목"/>'		,type: 'string'},			  			
//				 {name: 'ITEM_NAME'			,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'			,type: 'string'},			  			
//				 {name: 'SPEC'				,text:'<t:message code="system.label.sales.spec" default="규격"/>'			,type: 'string'},			  			
//				 {name: 'STOCK_UNIT'		,text:'<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'		,type: 'string', displayField: 'value'},			  			
//				 {name: 'SALE_UNIT'			,text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'		,type: 'string', displayField: 'value'},			  			
//				 {name: 'BASIS_P'			,text:'<t:message code="system.label.sales.sellingprice" default="판매단가"/>'		,type: 'string'},			  			
//				 {name: 'DOM_FORIGN'		,text:'내외자구분'		,type: 'string'},			  			
//				 {name: 'ITEM_ACCOUNT'  	,text:'<t:message code="system.label.sales.itemaccount" default="품목계정"/>'		,type: 'string'},			  			
//				 {name: 'TRNS_RATE'	 		,text:'<t:message code="system.label.sales.containedqty" default="입수"/>'			,type: 'string'}
//			]
//	});
//
//	//sbs030ukrvs1 store
//	var sbs030ukrvs1Store = Unilite.createStore('sbs030ukrvs1Store',{
//			model: 'sbs030ukrvs1Model',
//            //autoLoad: true,
//            uniOpt : {
//            	isMaster: false,			// 상위 버튼 연결 
//            	editable: false,			// 수정 모드 사용 
//            	deletable:false,			// 삭제 가능 여부 
//	            useNavi : false			// prev | next 버튼 사용
//            },
//            
//            proxy: {
//                type: 'direct',
//                api: {
//                	   read : 'sbs030ukrsService.selectList0_1'
//                }
//            }            
//            
//	});
	//sbs030ukrvs2_1 Model
	Unilite.defineModel('sbs030ukrvs2_1Model', {
	    fields: [{name: 'CUSTOM_CODE'		,text:'<t:message code="system.label.sales.client" default="고객"/>'		,type: 'string'},				 
				 {name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.sales.clientname" default="고객명"/>'		    ,type: 'string'},				 
				 {name: 'CUSTOM_TYPE'		,text:'고객구분'		,type: 'string'},				 
				 {name: 'AGENT_TYPE'		,text:'<t:message code="system.label.sales.clienttype" default="고객분류"/>'		,type: 'string'},				 
				 {name: 'TOP_NAME'			,text:'대표자'		    ,type: 'string'},				 
				 {name: 'TELEPHON'			,text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>'		,type: 'string'},				 
				 {name: 'ADDRESS'			,text:'<t:message code="system.label.sales.address" default="주소"/>'			,type: 'string'}				 
				 
			]
	});	
		
	//sbs030ukrvs2_1 store
	var sbs030ukrvs2_1Store = Unilite.createStore('sbs030ukrvs2_1Store',{
			model: 'sbs030ukrvs2_1Model',
            //autoLoad: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },            
            proxy: directProxy2_1,
            loadStoreRecords : function(){
                var param =  panelDetail.down('#sbs030ukrvs2Tab').getValues();
                this.load({
                    params: param
                });
            }            
            
	});
	
	//sbs030ukrvs2_2 Model
	Unilite.defineModel('sbs030ukrvs2_2Model', {
	    fields: [{name: 'CUSTOM_CODE'			,text:'<t:message code="system.label.sales.client" default="고객"/>'	,type: 'string', maxLength: 8},				 
				 {name: 'DVRY_CUST_SEQ'			,text:'<t:message code="system.label.sales.seq" default="순번"/>'		,type: 'int', allowBlank: false, maxLength: 4},				 
				 {name: 'DVRY_CUST_NM'			,text:'배송처명'	,type: 'string', allowBlank: false, maxLength: 40},				 
				 {name: 'DVRY_CUST_PRSN'		,text:'<t:message code="system.label.sales.charger" default="담당자"/>'	    ,type: 'string', maxLength: 20},				 
				 {name: 'DVRY_CUST_TEL'			,text:'<t:message code="system.label.sales.phoneno1" default="전화번호"/>'	,type: 'string', maxLength: 20},				 
				 {name: 'DVRY_CUST_FAX'			,text:'팩스번호'	,type: 'string', maxLength: 20},				 
				 {name: 'DVRY_CUST_ZIP'			,text:'우편번호'	,type: 'string', maxLength: 6},				 
				 {name: 'DVRY_CUST_ADD'			,text:'<t:message code="system.label.sales.address" default="주소"/>'		,type: 'string', maxLength: 200},				 
				 {name: 'REMARK'				,text:'<t:message code="system.label.sales.remarks" default="비고"/>'		,type: 'string', maxLength: 1000},				 
				 {name: 'BARCODE'				,text:'<t:message code="system.label.sales.barcode" default="바코드"/>'	    ,type: 'string'}				 
				  
			]
	});	
		
	//sbs030ukrvs2_2 store
	var sbs030ukrvs2_2Store = Unilite.createStore('sbs030ukrvs2_2Store',{
			model: 'sbs030ukrvs2_2Model',
            //autoLoad: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },            
            proxy: directProxy2_2,
            loadStoreRecords : function(){
                var param =  panelDetail.down('#sbs030ukrvs2Tab').getValues();
                this.load({
                    params: param
                });
            },
            saveStore : function()  {   
                var inValidRecs = this.getInvalidRecords();
                var rv = true;
                if(inValidRecs.length == 0 )    {
                    this.syncAllDirect();
                } else {
                     panelDetail.down('#sbs030ukrvs2_2Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }            
            
	});
	//sbs030ukrvs3 Model
	Unilite.defineModel('sbs030ukrvs3Model', {
	    fields: [
	    	{name: 'REMARK_TYPE'			,text:'적요구분'		,type: 'string'},
			{name: 'REMARK_CD'				,text:'적요코드'		,type: 'string', allowBlank: false, maxLength: 4},
			{name: 'REMARK_NAME'			,text:'적요명'		    ,type: 'string', allowBlank: false, maxLength: 50},
            {name: 'COMP_CODE'              ,text:'<t:message code="system.label.sales.compcode" default="법인코드"/>'        ,type: 'string'}				 
		]
	});

	//sbs030ukrvs3 store
	var sbs030ukrvs3Store = Unilite.createStore('sbs030ukrvs3Store',{
			model: 'sbs030ukrvs3Model',
            //autoLoad: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy3,
            loadStoreRecords : function(){
                var param =  panelDetail.down('#sbs030ukrvs3Tab').getValues();
                this.load({
                    params: param
                });
            },
            saveStore : function()  {   
                var inValidRecs = this.getInvalidRecords();
                var rv = true;
                if(inValidRecs.length == 0 )    {
                    this.syncAllDirect();
                } else {
                     panelDetail.down('#sbs030ukrvs3Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
	});
	//sbs030ukrvs4 Model
	Unilite.defineModel('sbs030ukrvs4Model', {
	    fields: [{name: 'DIV_CODE'			,text:'<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'			,type: 'string'},
			     {name: 'CUSTOM_CODE'		,text:'<t:message code="system.label.sales.client" default="고객"/>'			,type: 'string', allowBlank: false, maxLength: 8},
			     {name: 'CUSTOM_NAME'		,text:'<t:message code="system.label.sales.clientname" default="고객명"/>'			    ,type: 'string', allowBlank: false, maxLength: 20},
			     {name: 'MONEY_UNIT'		,text:'<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'			,type: 'string', allowBlank: false, maxLength: 3, comboType: 'AU', comboCode: 'B004', displayField: 'value'},
			     {name: 'BASIS_AMT_O'		,text:'기초잔액'			,type: 'uniPrice', maxLength: 18},
			     {name: 'BASIS_YYYYMM'		,text:'기초잔액반영연월'	,type: 'string', maxLength: 8},
			     {name: 'CREATE_LOC'		,text:'잔액생성경로'		,type: 'string'},
                 {name: 'UPDATE_DB_USER'    ,text:'UPDATE_DB_USER'      ,type: 'string'},
                 {name: 'UPDATE_DB_TIME'    ,text:'UPDATE_DB_TIME'      ,type: 'uniDate'},
                 {name: 'COMP_CODE'         ,text:'COMP_CODE'           ,type: 'string'}
			     
			]
	});
	//sbs030ukrvs4 store
	var sbs030ukrvs4Store = Unilite.createStore('sbs030ukrvs4Store',{
			model: 'sbs030ukrvs4Model',
            //autoLoad: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy4,
            loadStoreRecords : function(){
                var param =  panelDetail.down('#sbs030ukrvs4Tab').getValues();
                this.load({
                    params: param
                });
            },
            saveStore : function()  {   
                var inValidRecs = this.getInvalidRecords();
                var rv = true;
                var paramMaster = panelDetail.down('#sbs030ukrvs4Tab').getValues();
                if(inValidRecs.length == 0 )    {
                	config = {
                        params: [paramMaster],
                        success: function(batch, option) {
                        
                        } 
                    };
                    this.syncAllDirect(config);
                } else {
                     panelDetail.down('#sbs030ukrvs4Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            }
	});
//	//sbs030ukrvs5 Model
//	Unilite.defineModel('sbs030ukrvs5Model', {
//	    fields: [{name: 'DIV_CODE'					,text:'<t:message code="system.label.sales.division" default="사업장"/>'				,type: 'string'},				 
//				 {name: 'ITEM_CODE'					,text:'<t:message code="system.label.sales.item" default="품목"/>'				,type: 'string'},				 
//				 {name: 'ITEM_NAME'					,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'				,type: 'string'},				 
//				 {name: 'SPEC'						,text:'<t:message code="system.label.sales.spec" default="규격"/>'					,type: 'string'},				 
//				 {name: 'CUSTOM_CODE'				,text:'<t:message code="system.label.sales.client" default="고객"/>'				,type: 'string'},				 
//				 {name: 'MONEY_UNIT'				,text:'<t:message code="system.label.sales.currency" default="화폐"/>'					,type: 'string'},				 
//				 {name: 'ORDER_UNIT'				,text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'				,type: 'string', displayField: 'value'},				 
//				 {name: 'TRANS_RATE'				,text:'<t:message code="system.label.sales.containedqty" default="입수"/>'					,type: 'string'},				 
//				 {name: 'DC_START_DT'				,text:'할인시작일'				,type: 'string'},				 
//				 {name: 'DC_END_DT'					,text:'할인종료일'				,type: 'string'},				 
//				 {name: 'BASIS_ITEM_P'				,text:'적용단가'				,type: 'string'},				 
//				 {name: 'DC_RATE'					,text:'<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'				,type: 'string'},				 
//				 {name: 'DC_PRICE'					,text:'할인가'				,type: 'string'},				 
//				 {name: 'AGENT_TYPE'				,text:'<t:message code="system.label.sales.clienttype" default="고객분류"/>'				,type: 'string'},				 
//				 {name: 'DC_REMARK'					,text:'할인내역'				,type: 'string'},				 
//				 {name: 'UPDATE_DB_USER'			,text:'UPDATE_DB_USER'		,type: 'string'},				 
//				 {name: 'UPDATE_DB_TIME'			,text:'UPDATE_DB_TIME'		,type: 'string'},				 
//				 {name: 'COMP_CODE'					,text:'COMP_CODE'			,type: 'string'}
//			]
//	});
//	//sbs030ukrvs5 store
//	var sbs030ukrvs5Store = Unilite.createStore('sbs030ukrvs5Store',{
//			model: 'sbs030ukrvs5Model',
//            //autoLoad: true,
//            uniOpt : {
//            	isMaster: false,			// 상위 버튼 연결 
//            	editable: false,			// 수정 모드 사용 
//            	deletable:false,			// 삭제 가능 여부 
//	            useNavi : false			// prev | next 버튼 사용
//            },
//            
//            proxy: {
//                type: 'direct',
//                api: {
//                	   read : 'sbs030ukrsService.selectList0_1'
//                }
//            }            
//            
//	});
//	//sbs030ukrvs6_1 Model
//	Unilite.defineModel('sbs030ukrvs6_1Model', {
//	    fields: [{name: 'ITEM_CODE'					,text:'<t:message code="system.label.sales.item" default="품목"/>'		,type: 'string'},			  			
//				 {name: 'ITEM_NAME'					,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'		,type: 'string'},			  			
//				 {name: 'SPEC'						,text:'<t:message code="system.label.sales.spec" default="규격"/>'		,type: 'string'},			  			
//				 {name: 'ORDER_UNIT'				,text:'<t:message code="system.label.sales.salesunit" default="판매단위"/>'		,type: 'string', displayField: 'value'},			  			
//				 {name: 'TRANS_RATE'				,text:'<t:message code="system.label.sales.containedqty" default="입수"/>'		,type: 'string'},			  			
//				 {name: 'SALE_BASIS_P'				,text:'<t:message code="system.label.sales.sellingprice" default="판매단가"/>'		,type: 'string'},			  			
//				 {name: 'COMP_CODE'					,text:'COMP_CODE'		,type: 'string'}
//			]
//	});	
//
//	//sbs030ukrvs6_1 store
//	var sbs030ukrvs6_1Store = Unilite.createStore('sbs030ukrvs6Store',{
//			model: 'sbs030ukrvs6_1Model',
//            //autoLoad: true,
//            uniOpt : {
//            	isMaster: false,			// 상위 버튼 연결 
//            	editable: false,			// 수정 모드 사용 
//            	deletable:false,			// 삭제 가능 여부 
//	            useNavi : false			// prev | next 버튼 사용
//            },
//            
//            proxy: {
//                type: 'direct',
//                api: {
//                	   read : 'sbs030ukrsService.selectList0_1'
//                }
//            }            
//            
//	});	
//	
//	//sbs030ukrvs6_2 Model
//	Unilite.defineModel('sbs030ukrvs6_2Model', {
//	    fields: [{name: 'DIV_CODE'				,text: '<t:message code="system.label.sales.division" default="사업장"/>'			,type: 'string'},
//				 {name: 'ITEM_CODE'				,text: '<t:message code="system.label.sales.item" default="품목"/>'			,type: 'string'},
//				 {name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.client" default="고객"/>'			,type: 'string'},
//				 {name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'			,type: 'string'},
//				 {name: 'DC_START_DT'			,text: '할인시작일'		,type: 'string'},
//				 {name: 'DC_END_DT'				,text: '할인종료일'		,type: 'string'},
//				 {name: 'MONEY_UNIT'			,text: '<t:message code="system.label.sales.currency" default="화폐"/>'				,type: 'string'},
//				 {name: 'AGENT_TYPE'			,text: '고객구분'			,type: 'string'},
//				 {name: 'ORDER_UNIT'			,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'			,type: 'string', displayField: 'value'},
//				 {name: 'TRANS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'				,type: 'string'},
//				 {name: 'BASIS_ITEM_P'			,text: '적용단가'			,type: 'string'},
//				 {name: 'DC_RATE'				,text: '<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'		,type: 'string'},
//				 {name: 'DC_PRICE'				,text: '할인가'			,type: 'string'},
//				 {name: 'DC_REMARK'				,text: '할인내역'			,type: 'string'}				 
//			]
//	});	
//
//	//sbs030ukrvs6_2 store
//	var sbs030ukrvs6_2Store = Unilite.createStore('sbs030ukrvs6Store',{
//			model: 'sbs030ukrvs6_2Model',
//            //autoLoad: true,
//            uniOpt : {
//            	isMaster: false,			// 상위 버튼 연결 
//            	editable: false,			// 수정 모드 사용 
//            	deletable:false,			// 삭제 가능 여부 
//	            useNavi : false			// prev | next 버튼 사용
//            },
//            
//            proxy: {
//                type: 'direct',
//                api: {
//                	   read : 'sbs030ukrsService.selectList0_1'
//                }
//            }            
//            
//	});
//	//sbs030ukrvs7 Model
//	Unilite.defineModel('sbs030ukrvs7Model', {
//	    fields: [{name: 'COMP_CODE'      	,text:'<t:message code="system.label.sales.compcode" default="법인코드"/>'			,type: 'string'},				  			
//				 {name: 'MAIN_CODE'      	,text:'종합코드'			,type: 'string'},				  			
//				 {name: 'SUB_CODE'       	,text:'상세코드'			,type: 'string'},				  			
//				 {name: 'CODE_NAME'      	,text:'상세코드명'			,type: 'string'},				  			
//				 {name: 'CODE_NAME_EN'   	,text:'상세코드명'			,type: 'string'},				  			
//				 {name: 'CODE_NAME_CN'   	,text:'상세코드명'			,type: 'string'},				  			
//				 {name: 'CODE_NAME_JP'   	,text:'상세코드명'			,type: 'string'},				  			
//				 {name: 'REF_CODE1'      	,text:'적재량(단위:KG)'	,type: 'string'},				  			
//				 {name: 'REF_CODE2'      	,text:'주거래처코드'		,type: 'string'},				  			
//				 {name: 'CUSTOM_NAME'    	,text:'주거래처'			,type: 'string'},				  			
//				 {name: 'REF_CODE3'      	,text:'<t:message code="system.label.sales.division" default="사업장"/>'			,type: 'string'},				  			
//				 {name: 'REF_CODE4'      	,text:'관련4'				,type: 'string'},				  			
//				 {name: 'REF_CODE5'      	,text:'관련5'				,type: 'string'},				  			
//				 {name: 'REF_CODE6'      	,text:'관련6'				,type: 'string'},				  			
//				 {name: 'REF_CODE7'      	,text:'관련7'				,type: 'string'},				  			
//				 {name: 'REF_CODE8'      	,text:'관련8'				,type: 'string'},				  			
//				 {name: 'REF_CODE9'      	,text:'관련9'				,type: 'string'},				  			
//				 {name: 'REF_CODE10'     	,text:'관련10'			,type: 'string'},				  			
//				 {name: 'SUB_LENGTH'     	,text:'길이'				,type: 'string'},				  			
//				 {name: 'USE_YN'         	,text:'사용여부'			,type: 'string'},				  			
//				 {name: 'SORT_SEQ'       	,text:'정렬'				,type: 'string'},				  			
//				 {name: 'SYSTEM_CODE_YN' 	,text:'시스템'			,type: 'string'},				  			
//				 {name: 'INSERT_DB_USER' 	,text:'입력자'			,type: 'string'},				  			
//				 {name: 'INSERT_DB_TIME' 	,text:'입력일'			,type: 'string'},				  			
//				 {name: 'UPDATE_DB_USER' 	,text:'<t:message code="system.label.sales.updateuser" default="수정자"/>'			,type: 'string'},				  			
//				 {name: 'UPDATE_DB_TIME' 	,text:'<t:message code="system.label.sales.updatedate" default="수정일"/>'			,type: 'string'}
//			]
//	});
//	//sbs030ukrvs7 store
//	var sbs030ukrvs7Store = Unilite.createStore('sbs030ukrvs7Store',{
//			model: 'sbs030ukrvs7Model',
//            //autoLoad: true,
//            uniOpt : {
//            	isMaster: false,			// 상위 버튼 연결 
//            	editable: false,			// 수정 모드 사용 
//            	deletable:false,			// 삭제 가능 여부 
//	            useNavi : false			// prev | next 버튼 사용
//            },
//            
//            proxy: {
//                type: 'direct',
//                api: {
//                	   read : 'sbs030ukrsService.selectList0_1'
//                }
//            }
//	});
	
	//sbs030ukrvs8_1 Model
	Unilite.defineModel('sbs030ukrvs8_1Model', {
	    fields: [{name: 'COMP_CODE'		    	,text:'<t:message code="system.label.sales.compcode" default="법인코드"/>'			,type: 'string'},				 
				 {name: 'DIV_CODE'		    	,text:'<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'			,type: 'string'},				 
				 {name: 'SET_ITEM_CODE'	    	,text:'SET품목코드'		    ,type: 'string', allowBlank: false, maxLength: 20},				 
				 {name: 'CONST_ITEM_CODE'    	,text:'SET품목코드'		    ,type: 'string'},				 
				 {name: 'CONST_SEQ'		    	,text:'SET순번'			    ,type: 'int'},				 
				 {name: 'ITEM_NAME'		    	,text:'<t:message code="system.label.sales.setitemname" default="SET품목명"/>'			,type: 'string', maxLength: 40},				 
				 {name: 'SPEC'			    	,text:'<t:message code="system.label.sales.spec" default="규격"/>'				,type: 'string'},				 
				 {name: 'UPDATE_DB_USER'	    ,text:'UPDATE_DB_USER'	    ,type: 'string'},				 
				 {name: 'UPDATE_DB_TIME'	    ,text:'UPDATE_DB_TIME'	    ,type: 'uniDate'}
			]
	});
	//sbs030ukrvs8_1 store
	var sbs030ukrvs8_1Store = Unilite.createStore('sbs030ukrvs8_1Store',{
			model: 'sbs030ukrvs8_1Model',
            //autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy8_1,
            loadStoreRecords : function(){
                var param =  panelDetail.down('#sbs030ukrvs8Tab').getValues();
                this.load({
                    params: param
                });
            },
            listeners:{
                load: function(store, records, successful, eOpts) {
                    if(records != null && records.length > 0 ){
                        UniAppManager.setToolbarButtons('delete', true);
                    }
                },
                update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
                    UniAppManager.setToolbarButtons('save', true);      
                },
                datachanged : function(store,  eOpts) {
                    if( sbs030ukrvs8_1Store.isDirty() || store.isDirty()) {
                        UniAppManager.setToolbarButtons('save', true);  
                    }else {
                        UniAppManager.setToolbarButtons('save', false);
                    }
                }
            } 
	});
	
	//sbs030ukrvs8_2 Model
	Unilite.defineModel('sbs030ukrvs8_2Model', {
	    fields: [{name: 'DIV_CODE'		    	,text:'<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'			,type: 'string'},
				 {name: 'SET_ITEM_CODE'	    	,text:'SET품목코드'			,type: 'string', maxLength: 20},
				 {name: 'CONST_SEQ'		    	,text:'<t:message code="system.label.sales.seq" default="순번"/>'		        ,type: 'int', allowBlank: false, maxLength: 3},
                 {name: 'CONST_ITEM_CODE'       ,text:'<t:message code="system.label.sales.compitemcode" default="구성품목"/>'        ,type: 'string', allowBlank: false, maxLength: 20},
				 {name: 'ITEM_NAME'		    	,text:'<t:message code="system.label.sales.compitemname" default="구성품목명"/>'			,type: 'string'},
				 {name: 'SPEC'			    	,text:'<t:message code="system.label.sales.spec" default="규격"/>'				,type: 'string'},
				 {name: 'STOCK_UNIT'	    	,text:'<t:message code="system.label.sales.unit" default="단위"/>'				,type: 'string', displayField: 'value'},
				 {name: 'CONST_Q'		    	,text:'<t:message code="system.label.sales.compqty" default="구성수량"/>'			,type: 'uniQty', maxLength: 18},
				 {name: 'BASIS_SET_Q'	    	,text:'SET품목기준수'		,type: 'string', maxLength: 18},
				 {name: 'SO_KIND'		    	,text:'<t:message code="system.label.sales.ordertype" default="주문구분"/>'			,type: 'string', comboType: 'AU', comboCode: 'S065', maxLength: 20},
				 {name: 'USE_YN'		    	,text:'사용'				,type: 'string', maxLength: 1},
				 {name: 'REMARK'		    	,text:'<t:message code="system.label.sales.remarks" default="비고"/>'				,type: 'string', maxLength: 500},
				 {name: 'UPDATE_DB_USER'    	,text:'UPDATE_DB_USER'	    ,type: 'string'},
				 {name: 'UPDATE_DB_TIME'    	,text:'UPDATE_DB_TIME'	    ,type: 'uniDate'}
			]
	});
	//sbs030ukrvs8_2 store
	var sbs030ukrvs8_2Store = Unilite.createStore('sbs030ukrvs8_2Store',{
			model: 'sbs030ukrvs8_2Model',
            //autoLoad: true,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy8_2,
            loadStoreRecords : function(){
                var param =  panelDetail.down('#sbs030ukrvs8Tab').getValues();
                this.load({
                    params: param
                });
            },
            saveStore : function()  {   
                var inValidRecs = this.getInvalidRecords();
                var rv = true;
                if(inValidRecs.length == 0 )    {
                    this.syncAllDirect();
                } else {
                     panelDetail.down('#sbs030ukrvs8_2Grid').uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
            listeners:{
                load: function(store, records, successful, eOpts) {
                    if(records != null && records.length > 0 ){
                        UniAppManager.setToolbarButtons('delete', true);
                    }
                },
                update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
                    UniAppManager.setToolbarButtons('save', true);      
                },
                datachanged : function(store,  eOpts) {
                    if( sbs030ukrvs8_2Store.isDirty() || store.isDirty()) {
                        UniAppManager.setToolbarButtons('save', true);  
                    }else {
                        UniAppManager.setToolbarButtons('save', false);
                    }
                }
            } 
	});