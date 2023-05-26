<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tpl105ukrv" >
	<t:ExtComboStore comboType="BOR120"  /> 						<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="M103" /> 			<!-- 입고구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Tpl105ukrvModel1', {
	   fields: [
	   		/**	   		 
	   		 * type:
	   		 * 		uniQty		   -      수량
			 *		uniUnitPrice   -      단가
			 *		uniPrice	   -      금액(자사화폐)
			 *		uniPercent	   -      백분율(00.00)
			 *		uniFC          -      금액(외화화폐)
			 *		uniER          -      환율
			 *		uniDate        -      날짜(2999.12.31)
			 * maxLength: 입력가능한 최대 길이
	   		 * allowBlank: 필수 여부
	   		 * defaultValue: 기본값
	   		 * comboType:'AU', comboCode:'B014' : 그리드 콤보 사용시
			*/
	    	{name: 'SEQ'			, text: '순번'					, type: 'int', maxLength: 200, allowBlank: false},							//시퀀스 (editable: false)
	    	{name: 'COL1'			, text: '컬럼1'					, type: 'string', maxLength: 200},											//일반텍스트 Type
	    	{name: 'COL2'			, text: '컬럼2'					, type: 'string', maxLength: 200},											//팝업Type
	    	{name: 'COL3'			, text: '컬럼3'					, type: 'string', maxLength: 200, comboType: 'AU', comboCode: 'M103'},		//콤보박스Type
	    	{name: 'COL4'			, text: '컬럼4'					, type: 'uniDate', maxLength: 200},											//날짜Type
	    	{name: 'COL5'			, text: '컬럼5'					, type: 'uniPrice', maxLength: 200}											//금액Type
	    	
//	    	{name: 'INOUT_DATE'		, text: '입고일자'					, type: 'uniDate'	, maxLength: 8, allowBlank: false},
//	    	{name: 'SEQ'			, text: 'No.'					, type: 'int'		, maxLength: 5},
//	    	{name: 'INOUT_GUBUN'	, text: '입고구분'					, type: 'string'	, maxLength: 2},
//	    	{name: 'INOUT_NUM'		, text: '등록번호'					, type: 'string'	, maxLength: 20},
//	    	{name: 'CUSTOM_CODE'	, text: '거래처코드'				, type: 'string'	, maxLength: 20},
//	    	{name: 'CUSTOM_NAME'	, text: '거래처명'					, type: 'string'	, maxLength: 20},
//	    	{name: 'TOT_Q'			, text: '합계수량'					, type: 'uniQty'	, maxLength: 17},
//	    	{name: 'TOT_O'			, text: '합계금액'					, type: 'uniPrice'	, maxLength: 17},
//	    	{name: 'REMARK'			, text: '비고'					, type: 'string'	, maxLength: 50}	    	
	    ]
	});	
	
	Unilite.defineModel('Tpl105ukrvModel2', {
	   fields: [
	   		/**	   		 
	   		 * type:
	   		 * 		uniQty		   -      수량
			 *		uniUnitPrice   -      단가
			 *		uniPrice	   -      금액(자사화폐)
			 *		uniPercent	   -      백분율(00.00)
			 *		uniFC          -      금액(외화화폐)
			 *		uniER          -      환율
			 *		uniDate        -      날짜(2999.12.31)
			 * maxLength: 입력가능한 최대 길이
	   		 * allowBlank: 필수 여부
	   		 * defaultValue: 기본값
	   		 * comboType:'AU', comboCode:'B014' : 그리드 콤보 사용시
			*/
			{name: 'SEQ'			, text: '순번'					, type: 'int', maxLength: 200, allowBlank: false},							//시퀀스 (editable: false)
	    	{name: 'COL1'			, text: '컬럼1'					, type: 'string', maxLength: 200},											//일반텍스트 Type
	    	{name: 'COL2'			, text: '컬럼2'					, type: 'string', maxLength: 200},											//팝업Type
	    	{name: 'COL3'			, text: '컬럼3'					, type: 'string', maxLength: 200, comboType: 'AU', comboCode: 'M103'},		//콤보박스Type
	    	{name: 'COL4'			, text: '컬럼4'					, type: 'uniDate', maxLength: 200},											//날짜Type
	    	{name: 'COL5'			, text: '컬럼5'					, type: 'uniPrice', maxLength: 200}											//금액Type
	    	
//	    	{name: 'ITEM_CODE'		, text: '품목코드'					, type: 'string', maxLength: 20, allowBlank: false},
//	    	{name: 'ITEM_NAME'		, text: '품목명'					, type: 'string', maxLength: 40},
//	    	{name: 'SALE_P'			, text: '단가'					, type: 'uniUnitPrice', maxLength: 18},
//	    	{name: 'SALE_Q'			, text: '수량'					, type: 'uniQty', maxLength: 18},
//	    	{name: 'SALE_O'			, text: '금액'					, type: 'uniPrice', maxLength: 18},
//	    	{name: 'REMARK'			, text: '적요'					, type: 'string', maxLength: 100}  
	    ]
	});
	/**
	 * masterStore Proxy정의
	 */		
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'templateService.selectMaster',			//조회
			update: 'templateService.updateMaster',			//수정
			create: 'templateService.insertMaster',			//입력
			destroy: 'templateService.deleteMaster',		//삭제
			syncAll: 'templateService.saveAll'				//저장
		}
	});

	/**
	 * masterStore 정의
	 */	
	var directMasterStore = Unilite.createStore('tpl105MasterStore',{
		model: 'Tpl105ukrvModel1',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true			// 삭제 가능 여부
        },        
        proxy: directProxy1 
		,loadStoreRecords : function()	{
			var param= panelSearch.getValues();		//조회폼 파라미터 수집		
			console.log( param );
			this.load({								//그리드에 Load..
				params : param,
				callback : function(records, operation, success) {
					if(success)	{	//조회후 처리할 내용
					
					}
				}
			});
		}
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		,saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();		//필수값 입력여부 체크
			if(inValidRecs.length == 0 )	{
				var config = {
					params:[panelSearch.getValues()],		//조회조건 param
					success : function()	{				//저장후 실행될 로직
						
					}
				}
				this.syncAllDirect(config);			//저장 로직 실행	
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);	//에러 발생
			}
		}
        
	});
	
	/**
	 * detailStore Proxy정의
	 */		
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'templateService.selectDetail'			//조회
//			update: 'templateService.updateDetail',			//수정
//			create: 'templateService.insertDetail',			//입력
//			destroy: 'templateService.deleteDetail',		//삭제
//			syncAll: 'templateService.saveAll'				//저장
		}
	});

	/**
	 * detailStore 정의
	 */	
	var directDetailStore = Unilite.createStore('tpl105DetailStore',{
		model: 'Tpl105ukrvModel2',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,		// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:true			// 삭제 가능 여부
        },        
        proxy: directProxy2 
		,loadStoreRecords : function(params)	{
			var param= panelSearch.getValues();		//조회폼 파라미터 수집		
			param.SEQ = params.SEQ;                 //마스터그리드 SEQ 
			console.log( param );
			this.load({								//그리드에 Load..
				params : param,
				callback : function(records, operation, success) {
					if(success)	{	//조회후 처리할 내용
					
					}
				}
			});
		}
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		,saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();		//필수값 입력여부 체크
			if(inValidRecs.length == 0 )	{
				directMasterStore.syncAllDirect(config);	//저장 로직 실행
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);	//에러 발생
			}
		}
        
	});
	
	/**
	 * 좌측 검색조건 (panelSearch)
	 */
	var panelSearch = Unilite.createSearchPanel('tpl105SearchForm', {
		title: '검색조건',         
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,	//사용할 조회 폼
        listeners: {	//화면 사용 안하는 조회폼 hide 
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{     
			title: '기본정보',   
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
	    	items : [{
	    		xtype:'container',
	    		layout : {type : 'uniTable', columns : 1},	//1열 종대형 테이블 레이아웃
	    		items:[{
					xtype:'uniDatefield',			//필드 타입
					fieldLabel: '입고일자'  ,
					name: 'INOUT_DATE',				//Query mapping name
					value: UniDate.get('today'),	//화면 open시 Default되어 보여질 값
					allowBlank:false,				//필수(*)여부
					colspan: 2,						//컬럼 병합
					listeners: {//이벤트 작성
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('INOUT_DATE', newValue);		//비활성화된 검색폼과 동기화 시키기 위해					
						}
					}
			     },{
	            	xtype: 'uniCombobox',
	            	fieldLabel: '입고구분',
	            	name: 'INOUT_GUBUN',
	            	comboType: 'AU',	//AU: 미사용 포함
	            	comboCode: 'M103',  //사용할 공통코드  
	            	allowBlank: false,
	            	value : '',	
//	            	labelWidth: 110,	//라벨폭 길이 설정
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('GUBUN', newValue);
						}
					}
				},
		    	//팝업사용
				UniTempPopup.popup('TEMPLATE', { 
					fieldLabel: '거래처', 				//UniPopup.js에 정의된 컨피그값 override 가능
					valueFieldName: 'TEMPLATE_CODE',	//UniPopup.js에 정의된 컨피그값 override 가능
			   	 	textFieldName: 'TEMPLATE_NAME',		//UniPopup.js에 정의된 컨피그값 override 가능
//			   	 	validateBlank:false,				//validator처리후 클리어 할 것인지 여부..
//			   	 	autoPopup:true,						//validator처리후 팝업 자동open 할 것인지 여부..
					listeners: {
						onSelected: {	//팝업에서 값 선택후 처리
							fn: function(records, type) {
								panelResult.setValue('TEMPLATE_CODE', panelSearch.getValue('TEMPLATE_CODE'));
								panelResult.setValue('TEMPLATE_NAME', panelSearch.getValue('TEMPLATE_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{	//팝업에서 값 클리어후 처리
							panelResult.setValue('TEMPLATE_CODE', '');
							panelResult.setValue('TEMPLATE_NAME', '');
						},
//						onValueFieldChange: function(field, newValue){				//value필드 수정후 이벤트
//							panelResult.setValue('//value필드 수정후 이벤트', newValue);								
//						},
//						onTextFieldChange: function(field, newValue){				//text필드 수정후 이벤트
//							panelResult.setValue('TEMPLATE_NAME', newValue);				
//						},
						applyextparam: function(popup){		//팝업 쿼리 호출시 파라미터 add					
							var divCode = '';									
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}
					}
				})]	
			}]
		}]
	});
	
	
	/**
	 * 상단 검색조건 (panelSearch)
	 */	
	var panelResult = Unilite.createSearchForm('tpl105ResultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3/*, tableAttrs: {width: '100%'}*/},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
    		xtype:'container',
    		layout : {type : 'uniTable', columns : 2},	//2열 종대형 테이블 레이아웃
    		items:[{
				xtype:'uniDatefield',			//필드 타입
				fieldLabel: '입고일자'  ,
				name: 'INOUT_DATE',				//Query mapping name
				value: UniDate.get('today'),	//화면 open시 Default되어 보여질 값
				allowBlank:false,				//필수(*)여부
				colspan: 2,						//컬럼 병합
				listeners: {//이벤트 작성
					change: function(combo, newValue, oldValue, eOpts) {					
						panelSearch.setValue('INOUT_DATE', newValue);		//비활성화된 검색폼과 동기화 시키기 위해					
					}
				}
		     },{
            	xtype: 'uniCombobox',
            	fieldLabel: '입고구분',
            	name: 'INOUT_GUBUN',
            	comboType: 'AU',	//AU: 미사용 포함
            	comboCode: 'M103',  //사용할 공통코드  
            	allowBlank: false,
            	value : '',	
//	            	labelWidth: 110,	//라벨폭 길이 설정
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('GUBUN', newValue);
					}
				}
			},
	    	//팝업사용
			UniTempPopup.popup('TEMPLATE', { 
				fieldLabel: '거래처', 				//UniPopup.js에 정의된 컨피그값 override 가능
				valueFieldName: 'TEMPLATE_CODE',	//UniPopup.js에 정의된 컨피그값 override 가능
		   	 	textFieldName: 'TEMPLATE_NAME',		//UniPopup.js에 정의된 컨피그값 override 가능
//			   	validateBlank:false,				//validator처리후 클리어 할 것인지 여부..
//		   	 	autoPopup:true,						//validator처리후 팝업 자동open 할 것인지 여부..
				listeners: {
					onSelected: {	//팝업에서 값 선택후 처리
						fn: function(records, type) {
							panelSearch.setValue('TEMPLATE_CODE', panelResult.getValue('TEMPLATE_CODE'));
							panelSearch.setValue('TEMPLATE_NAME', panelResult.getValue('TEMPLATE_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{	//팝업에서 값 클리어후 처리
						panelSearch.setValue('TEMPLATE_CODE', '');
						panelSearch.setValue('TEMPLATE_NAME', '');
					},
//					onValueFieldChange: function(field, newValue){				//value필드 수정후 이벤트
//						panelSearch.setValue('//value필드 수정후 이벤트', newValue);								
//					},
//					onTextFieldChange: function(field, newValue){				//text필드 수정후 이벤트
//						panelSearch.setValue('TEMPLATE_NAME', newValue);				
//					},
					applyextparam: function(popup){		//팝업 쿼리 호출시 파라미터 add					
						var divCode = '';									
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						
					}
				}
			})]	
		}]	
    });
    
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('tpl105MasterGrid', {
    	layout : 'fit',		//화면 꽉차는 layout
        region : 'center',
		store: directMasterStore,		//스토어 mapping
    	uniOpt: {
    		expandLastColumn: false,	//마지막컬럼 존재 여부
		 	useRowNumberer: true,		//순번표시 여부
		 	onLoadSelectFirst : false,
		 	copiedRow: true				//행복사 기능 사용 여부
        },
    	/*selModel: Ext.create('Ext.selection.CheckboxModel', {	//그리드 체크박스 사용
        	checkOnly: true,
        	toggleOnClick: false,
        	listeners: { 
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			
        		},
				select: function(grid, record, index, eOpts ){					
					
	          	},
				deselect: function(grid, record, index, eOpts ){		
					
        		}
        	}
        }),*/
//    	features: [{		//합계행 표시 처리
//    		id: 'masterGridSubTotal',
//    		ftype: 'uniGroupingsummary', 
//    		showSummaryRow: false 
//    	},{
//    		id: 'masterGridTotal', 	
//    		ftype: 'uniSummary', 	  
//    		showSummaryRow: false
//    	}],
        columns: [
        		  {dataIndex: 'SEQ'			, width: 60},
        		  {dataIndex: 'COL1'			, width: 120},
        		  {dataIndex: 'COL2'			, width: 120, 
				    	editor: UniTempPopup.popup('TEMPLATE_G', {	
				    		DBtextFieldName: 'TEMPLATE_CODE',	//CODE를 조회하는 팝업 일시에는 정의를 해줘야함..	
				     	 	autoPopup:true,						//validator처리후 팝업 자동open 할 것인지 여부..				   	 	
		 		  		listeners: {'onSelected': {
				  				fn: function(records, type) {
				                      console.log('records : ', records);
				                      Ext.each(records, function(record,i) {		//팝업창에서 선택된 레코드 처리											                   
				  	        			if(i==0) {
				  							masterGrid.uniOpt.currentRecord.set('COL2', record['TMP_CD']);	//masterGrid에 팝업에서 선택된 record를 SET
				  	        			} else {
                  
				  	        			}
				  					}); 
				  				},
				  				scope: this
				  			},
				  			'onClear': function(type) {
//				  				masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
				  			},
				  			applyextparam: function(popup){
				  				var divCode = UserInfo.divCode;
				  				popup.setExtParam({'DIV_CODE': divCode});
				  			}
				  		}
				  	 })
				  },        		
        		  {dataIndex: 'COL3'			, width: 120},
        		  {dataIndex: 'COL4'			, width: 120},
        		  {dataIndex: 'COL5'			, width: 120}
        		
//        		  {dataIndex: 'INOUT_DATE'		, width: 120},
//        		  {dataIndex: 'SEQ'				, width: 80},
//        		  {dataIndex: 'INOUT_GUBUN'		, width: 120},
//        		  {dataIndex: 'INOUT_NUM'		, width: 120},
//        		  {dataIndex: 'CUSTOM_CODE'		,		width:120, 
//				  	editor: Unilite.popup('TEMPLATE_G', {		
////	 	 				textFieldName: 'CUSTOM_CODE',
////	 	 				DBtextFieldName: 'CUSTOM_CODE',
//				   	 	autoPopup:true,						//validator처리후 팝업 자동open 할 것인지 여부..
//	 	 				useBarcodeScanner: false,
//		 				listeners: {'onSelected': {
//								fn: function(records, type) {
//				                    console.log('records : ', records);
//				                    Ext.each(records, function(record,i) {		//팝업창에서 선택된 레코드 처리											                   
//					        			if(i==0) {
////											masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
//					        			} else {
//					        				UniAppManager.app.onNewDataButtonDown();
////					        				masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
//					        			}
//									}); 
//								},
//								scope: this
//							},
//							'onClear': function(type) {
////								masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
//							},
//							applyextparam: function(popup){
//								var divCode = UserInfo.divCode;
//								popup.setExtParam({'DIV_CODE': divCode});
//							}
//						}
//					 })
//				  },
//				  {dataIndex: 'CUSTOM_NAME'		,		width:300,
//				  	DBtextFieldName: 'CUSTOM_NAME',
//				  	autoPopup:true,						//validator처리후 팝업 자동open 할 것인지 여부..
//				  	editor: Unilite.popup('TEMPLATE_G', {
//						listeners: {'onSelected': {
//								fn: function(records, type) {
//				                    console.log('records : ', records);
//				                    Ext.each(records, function(record,i) {			//팝업창에서 선택된 레코드 처리										                   
//					        			if(i==0) {
////											masterGrid.setItemData(record,false, masterGrid.uniOpt.currentRecord);
//					        			} else {
//					        				UniAppManager.app.onNewDataButtonDown();
////					        				masterGrid.setItemData(record,false, masterGrid.getSelectedRecord());
//					        			}
//									}); 
//								},
//								scope: this
//							},
//							'onClear': function(type) {
////								masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
//							},
//							applyextparam: function(popup){
//								var divCode = UserInfo.divCode;
//								popup.setExtParam({'DIV_CODE': divCode});
//							}
//						}
//					})
//				  },
//        		  {dataIndex: 'TOT_Q'			, width: 120},
//        		  {dataIndex: 'REMARK'			, minWidth: 300, flex: 1}
		],                  
		listeners: {
      		beforeedit  : function( editor, e, eOpts ) {	//수정전 editable 처리..
      		if(!e.record.phantom){//신규행 일시
      			if (UniUtils.indexOf(e.field, ['SEQ', 'ACCNT_CD'])){
					return false;
					}
				}      		
      		},
      		selectionchange: function( grid, selected, eOpts) {	//masterGrid 행 선택시 detailGrid 화면 조회
        		if(selected && selected.length == 1)	{
	        		var param = {
	        			'SEQ'				: selected[0].get('SEQ'),
	        		}
	        		directDetailStore.loadStoreRecords(param);
        		}
        	}
  			 
		} 
    });    
    
    /**
     * Detail Grid 정의(Grid Panel)
     * @type 
     */
    
    var detailGrid = Unilite.createGrid('tpl105DetailGrid', {
    	layout : 'fit',		//화면 꽉차는 layout
        region : 'south',
		store: directDetailStore,		//스토어 mapping
    	uniOpt: {
    		expandLastColumn: false,	//마지막컬럼 존재 여부
		 	useRowNumberer: true,		//순번표시 여부
		 	copiedRow: true				//행복사 기능 사용 여부
        },
    	features: [{		//합계행 표시 처리
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [
        		  {dataIndex: 'SEQ'			, width: 60},
        		  {dataIndex: 'COL1'			, width: 120},
        		  {dataIndex: 'COL2'			, width: 120, 
				    	editor: UniTempPopup.popup('TEMPLATE_G', {	
				    		DBtextFieldName: 'TEMPLATE_CODE',	//CODE를 조회하는 팝업 일시에는 정의를 해줘야함..	
				     	 	autoPopup:true,						//validator처리후 팝업 자동open 할 것인지 여부..				   	 	
		 		  		listeners: {'onSelected': {
				  				fn: function(records, type) {
				                      console.log('records : ', records);
				                      Ext.each(records, function(record,i) {		//팝업창에서 선택된 레코드 처리											                   
				  	        			if(i==0) {
				  							masterGrid.uniOpt.currentRecord.set('COL2', record['TMP_CD']);	//masterGrid에 팝업에서 선택된 record를 SET
				  	        			} else {
                  
				  	        			}
				  					}); 
				  				},
				  				scope: this
				  			},
				  			'onClear': function(type) {
//				  				masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
				  			},
				  			applyextparam: function(popup){
				  				var divCode = UserInfo.divCode;
				  				popup.setExtParam({'DIV_CODE': divCode});
				  			}
				  		}
				  	 })
				  },        		
        		  {dataIndex: 'COL3'			, width: 120},
        		  {dataIndex: 'COL4'			, width: 120},
        		  {dataIndex: 'COL5'			, width: 120}
//        		  {dataIndex: 'ITEM_CODE'		, width: 120},
//        		  {dataIndex: 'ITEM_NAME'		, width: 300},
//        		  {dataIndex: 'SALE_P'			, width: 120},
//        		  {dataIndex: 'SALE_Q'			, width: 120},
//        		  {dataIndex: 'SALE_O'			, width: 120},
//        		  {dataIndex: 'REMARK'			, minWidth: 300, flex: 1}	//flex: 자리 차지하는 비율
		], 
		listeners: {
      		beforeedit  : function( editor, e, eOpts ) {	//수정전 editable 처리..
      		if(!e.record.phantom){//신규행 일시
      			if (UniUtils.indexOf(e.field, ['SEQ', 'ACCNT_CD'])){
					return false;
					}
				}      		
      		}
  			 
		} 
    });   
    
	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',	//'east', 'west', 'south', 'north'
			border: false,
			items:[		//component layout 배치
				panelResult, masterGrid, detailGrid 
			]
		},
			panelSearch  	
		], 
		id : 'tpl105App',
		fnInitBinding : function(params) {
			/**
			 * 화면 오픈시 UserInfo정보
			 *  singleton: true,
		     *  userID: 		"misoon",
		     *  userName: 		"홍길동",
		     *  personNumb: 	"1999041900",
		     *  divCode: 		"01",
		     *  deptCode: 		"0101",
		     *  deptName: 		"관리부",
		     *  compCode: 		"MASTER",
		     *  currency:  		'KRW',
		     *  userLang:		'KR',
		     *  compCountry:	'KR',
			 *  appOption.collapseLeftSearch: 좌측폼 collapse 여부 
			*/
			panelSearch.setValue('INOUT_DATE', UniDate.get('today'));	//초기값 세팅
			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);	//main 버튼 활성화 여부
			UniAppManager.setToolbarButtons('save', false);
//			this.processParams(params);		
			
			//화면 오픈시 입고일자에 focus 및 select 처리
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('INOUT_DATE');
		},
		onQueryButtonDown : function()	{			//조회버튼 클릭시
			if(!this.isValidSearchForm()){			//조회전 필수값 입력 여부 체크
				return false;
			}
			directMasterStore.loadStoreRecords();	//Store 조회 함수 호출
		},
		onResetButtonDown: function() {				//신규버튼 클릭시
			masterGrid.reset();						//그리드 reset
			directMasterStore.clearData();			//스토어 Clear
			this.fnInitBinding();					//초기화 함수 호출
		},
		onNewDataButtonDown : function()	{//추가버튼 클릭시 
        	 var seq = directMasterStore.max('SEQ');
        	 if(!seq) seq = 1;
        	 else  seq += 1;
        	 var r = { 
				SEQ: seq	
	        };	        
			masterGrid.createRow(r, 'COL1');	//행 생성시 default값 세팅 및 포커스 지정
		},
		 onDeleteDataButtonDown: function() {	//삭제버튼 클릭시	
		 	var selRow = masterGrid.getSelectedRecord();		 	
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();				
			}			
		},
		onSaveDataButtonDown: function () {	//저장버튼 클릭시
			directMasterStore.saveStore();
		},
		processParams: function(params) {	//링크로 넘어올시 처리 부분 
			
		}
	});
	
	Unilite.createValidator('validator01', {		//그리드 수정후 validator 체크
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}			
			var rv = true;			
			switch(fieldName) {
				case "REMARK" :		
					if(true)	{
						rv=Msg.sMH1442;	//Message-ko.js 오류메시지 참조
					}
					break;					
			}
			return rv;
		}
	}); 
};

</script>