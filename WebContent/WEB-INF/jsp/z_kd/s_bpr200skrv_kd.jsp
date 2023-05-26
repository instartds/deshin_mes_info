<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bpr200skrv_kd"  >
	<t:ExtComboStore comboType="BOR120" /><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /><!-- 예(Y)/아니오(N) -->
	
    <t:ExtComboStore comboType="AU" comboCode="B014" /><!-- 조달구분 -->
    <t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 재고단위 -->
    <t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
    
	<t:ExtComboStore comboType="AU" comboCode="B018" /><!-- 예(1)/아니오(2) -->
	<t:ExtComboStore comboType="AU" comboCode="B059" /><!-- 세구분 -->
	<t:ExtComboStore comboType="AU" comboCode="WB04" /><!-- 차종 -->
	
	<t:ExtComboStore comboType="AU" comboCode="B019" /><!-- 국내외 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B023" /><!-- 실적입고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="B061" /><!-- 발주방침 -->
	<t:ExtComboStore comboType="AU" comboCode="B037" /><!-- ABC구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B039" /><!-- 출고방법 -->
	
	<t:ExtComboStore comboType="AU" comboCode="B061" /><!-- Lot sizing -->
	<t:ExtComboStore comboType="OU" /><!-- 창고  -->
	<t:ExtComboStore comboType="WU" /><!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B052" /><!-- 품목정보검색항목 -->
	
	<t:ExtComboStore comboType="AU" comboCode="P006" /><!-- 생산방식 -->
	<t:ExtComboStore comboType="AU" comboCode="Q005" /><!-- 수입검사방법 -->
	<t:ExtComboStore comboType="AU" comboCode="Q006" /><!-- 공정검사방법 -->
	<t:ExtComboStore comboType="AU" comboCode="Q007" /><!-- 출하검사방법 -->
	
	<t:ExtComboStore comboType="AU" comboCode="M201" /><!-- 구매담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B074" /><!-- 양산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B093" /><!-- 공정구분  -->
    <t:ExtComboStore comboType="AU" comboCode="WB19" /><!-- 출고부서구분 -->

	<t:ExtComboStore items="${COMBO_DIV_PRSN}" storeId="BPR250ukrvDIV_PRSNStore" />
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
	Unilite.defineModel('Bpr200skrModel', {
		fields: [ 
	  		  	 {name: 'COMP_CODE'    				,text:'<t:message code="unilite.msg.sMB183" default="법인"/>'  		     ,type : 'string'}                             
				,{name: 'ITEM_CODE'    				,text:'<t:message code="unilite.msg.sMR004" default="품목코드"/>'           ,type : 'string'}                            
				,{name: 'ITEM_NAME'    				,text:'<t:message code="unilite.msg.sMR005" default="품목명"/>'            ,type : 'string'}                              				          
				,{name: 'SPEC'    					,text:'<t:message code="unilite.msg.sMR006" default="규격"/>'         	 ,type : 'string'}                                                      
				
				,{name: 'BCNT'    					,text:'<t:message code="unilite.msg.sMR391" default="BOM등록"/>'          ,type : 'string', comboType:'AU', comboCode:'B018'}                                                   
				,{name: 'BCNT1'    					,text:'<t:message code="unilite.msg.sMR355" default="구매단가"/>'          ,type : 'string', comboType:'AU', comboCode:'B018'}                                                  
				,{name: 'BCNT2'    					,text:'<t:message code="unilite.msg.sMR393" default="판매단가"/>'          ,type : 'string', comboType:'AU', comboCode:'B018'}                                                  
				,{name: 'STOCK_UNIT'    			,text:'<t:message code="unilite.msg.sMR036" default="재고단위"/>'          ,type : 'string'}                                                  
				,{name: 'SALE_UNIT',  			    text: '판매단위', 		type : 'string', comboType:'AU', comboCode:'B013', displayField: 'value'}      
		  		,{name: 'TRNS_RATE',  			    text: '판매입수', 		type : 'uniUnitPrice'}           
		  		,{name: 'TAX_TYPE',  			    text: '세구분', 		type : 'string', comboType:'AU', comboCode:'B059'}         
		  		,{name: 'SALE_BASIS_P',  	 	    text: '판매단가', 		type : 'uniUnitPrice'}
		  		
		  		,{ name: 'CAR_TYPE',  			    text: '차종', 		type : 'string', comboType:'AU', comboCode:'WB04'} 
		  		,{ name: 'OEM_ITEM_CODE',  		    text: '품번', 		type : 'string'} 
		  		,{ name: 'AS_ITEM_CODE',  		    text: 'AS코드', 		type : 'string'} 
		  		,{ name: 'B_OUT_YN',    		    text:'밸런스아웃여부',   type : 'string', comboType:'AU', comboCode:'A020'}  
		  		,{ name: 'B_OUT_DATE',  		    text: '밸런스아웃일자', 	type : 'uniDate'}  
		  		,{ name: 'MAKE_STOP_YN',    	    text:'생산중지여부',    type : 'string', comboType:'AU', comboCode:'A020'} 
		  		,{ name: 'MAKE_STOP_DATE',  	    text: '생산중지일자', 	type : 'uniDate'}
                ,{ name: 'AUTO_EXAM_YN',            text:'자동검수예외',    type : 'string', comboType:'AU', comboCode:'B010'}
                ,{ name: 'DEPT_GUBUN',              text:'출고부서구분',    type : 'string', comboType:'AU', comboCode:'WB19'}
		  		
		  		,{name: 'ITEM_LEVEL1'    			,text:'<t:message code="unilite.msg.sMR043" default="대분류"/>'           ,type : 'string'}  
				,{name: 'ITEM_LEVEL2'    			,text:'<t:message code="unilite.msg.sMR044" default="중분류"/>'           ,type : 'string'}                                                  
				,{name: 'ITEM_LEVEL3'    			,text:'<t:message code="unilite.msg.sMR045" default="소분류"/>'           ,type : 'string'}                                                  
				
				,{name: 'ITEM_ACCOUNT'    			,text:'<t:message code="unilite.msg.sMR278" default="품목계정"/>'         ,type : 'string'	, comboType:'AU', comboCode:'B020'}                            
				,{name: 'SUPPLY_TYPE'    			,text:'<t:message code="unilite.msg.sMR351" default="조달구분"/>'         ,type : 'string'	, comboType:'AU', comboCode:'B014'}                            
				,{name: 'ORDER_UNIT'    			,text:'<t:message code="unilite.msg.sMR174" default="구매단위"/>'         ,type : 'string'	, comboType:'AU', comboCode:'B013', displayField: 'value'}                             
				,{name: 'TRNS_RATE'    			    ,text:'구매입수'                                                          ,type : 'uniER'	}                             
				
				,{name: 'WH_CODE'    				,text:'<t:message code="unilite.msg.sMR352" default="주창고"/>'           ,type : 'string'	, comboType:'OU'}                             
				,{name: 'LOCATION'    				,text:'<t:message code="unilite.msg.sMR348" default="Location"/>'       ,type : 'string'}                                                  
				,{name: 'ORDER_PLAN'    			,text:'<t:message code="unilite.msg.sMR353" default="발주방침"/>'          ,type : 'string'	, comboType:'AU', comboCode:'B061'}                            
				,{name: 'MATRL_PRESENT_DAY'   		,text:'<t:message code="unilite.msg.sMR354" default="자재올림기간"/>'       ,type : 'uniPrice'}                                                 
				,{name: 'PURCHASE_BASE_P'    		,text:'<t:message code="unilite.msg.sMR355" default="구매단가"/>'          ,type : 'uniUnitPrice'}                                                      
				,{name: 'ORDER_PRSN'    			,text:'<t:message code="unilite.msg.fsbMsgB0012" default="자사구매담당"/>'  ,type : 'string', comboType:'AU', comboCode:'M201'}                                                  
				,{name: 'ABC_FLAG'    				,text:'<t:message code="unilite.msg.sMR203" default="ABC구분"/>'         ,type : 'string', comboType:'AU', comboCode:'B037'}    
				,{name: 'LOT_YN'    				,text:'LOT관리여부'                                                        ,type : 'string' , comboType:'AU', comboCode:'A020'}  
				,{name: 'PHANTOM_YN'    			,text:'팬텀여부'                                                           ,type : 'string' , comboType:'AU', comboCode:'A020'}  
				,{name: 'EXCESS_RATE'    			,text:'<t:message code="unilite.msg.sMR356" default="과입고허용율"/>'       ,type : 'uniPercent' }                            
				,{name: 'EXPENSE_RATE'    			,text:'<t:message code="unilite.msg.sMR184" default="수입부대비용율"/>'      ,type : 'uniPercent' }                                               
				//MRP정보
				,{name: 'ORDER_KIND'    			,text:'<t:message code="unilite.msg.sMR357" default="오더생성여부"/>'      ,type : 'string', comboType:'AU', comboCode:'A020'}                                               
				,{name: 'NEED_Q_PRESENT'    		,text:'<t:message code="unilite.msg.sMR358" default="소요량올림구분"/>'     ,type : 'string', comboType:'AU', comboCode:'A020'}                                            
				,{name: 'EXC_STOCK_CHECK_YN'  		,text:'<t:message code="unilite.msg.sMR359" default="가용재고체크"/>'      ,type : 'string', comboType:'AU', comboCode:'A020'}                                              
				,{name: 'SAFE_STOCK_Q'    			,text:'<t:message code="unilite.msg.sMR183" default="안전재고량"/>'       ,type : 'uniPrice'}                                                  
				,{name: 'NEED_Q_PRESENT_Q'    		,text:'<t:message code="unilite.msg.sMR360" default="소요량올림수"/>'      ,type : 'uniQty'}   //uniQty 
				//구매정보
				,{name: 'PURCH_LDTIME'    			,text:'<t:message code="unilite.msg.sMR382" default="구매 L/T"/>'       ,type : 'int'}                                                     
				,{name: 'MINI_PURCH_Q'    			,text:'<t:message code="unilite.msg.sMR198" default="최소발주량"/>'       ,type : 'uniQty'}                                                   
				,{name: 'MAX_PURCH_Q'    			,text:'<t:message code="unilite.msg.sMR362" default="최대발주량"/>'       ,type : 'uniQty'}                                                   
				,{name: 'CUSTOM_CODE'    			,text:'<t:message code="unilite.msg.sMR363" default="주거래처코드"/>'      ,type : 'string'}                                               
				,{name: 'CUSTOM_NAME'    			,text:'<t:message code="unilite.msg.sMR364" default="주거래처"/>'        ,type : 'string'}                                                 
				//
				,{name: 'ROP_YN'    				,text:'<t:message code="unilite.msg.sMR365" default="ROP대상여부"/>'     ,type : 'string' , comboType:'AU', comboCode:'A020'}                                               
				,{name: 'DAY_AVG_SPEND'    			,text:'<t:message code="unilite.msg.sMR366" default="일일평균소비량"/>'    ,type : 'uniQty'	 }                      
				,{name: 'ORDER_POINT'    			,text:'<t:message code="unilite.msg.sMR367" default="고정발주량"/>'       ,type : 'uniQty'	 }                           
				,{name: 'BASIS_P'    				,text:'<t:message code="unilite.msg.sMR368" default="재고단가"/>'        ,type : 'uniUnitPrice'}                                                     
				,{name: 'COST_YN'    				,text:'<t:message code="unilite.msg.sMR369" default="원가계산대상"/>'     ,type : 'string' , comboType:'AU', comboCode:'A020'}                                              
				,{name: 'COST_PRICE'    			,text:'<t:message code="unilite.msg.sMR370" default="원가"/>'           ,type : 'uniPrice'}                                                       
				,{name: 'REAL_CARE_YN'    			,text:'<t:message code="unilite.msg.sMR371" default="실사대상"/>'        ,type : 'string' , comboType:'AU', comboCode:'A020'}                                                  
				,{name: 'REAL_CARE_PERIOD'    		,text:'<t:message code="unilite.msg.sMR372" default="실사주기"/>'        ,type : 'int'}                                                      
				,{name: 'MINI_PACK_Q'    			,text:'<t:message code="unilite.msg.sMR432" default="최소포장단위"/>'     ,type : 'uniQty'}  
				//생산정보
				,{name: 'ORDER_METH'    			,text:'<t:message code="unilite.msg.sMR373" default="생산방식"/>'         ,type : 'string', comboType:'AU', comboCode:'P006'}                                                  
				,{name: 'OUT_METH'    				,text:'<t:message code="unilite.msg.sMR374" default="출고방법"/>'         ,type : 'string', comboType:'AU', comboCode:'B039'}                                                  
				,{name: 'RESULT_YN'    				,text:'<t:message code="unilite.msg.sMR375" default="실적입고방법"/>'      ,type : 'string', comboType:'AU', comboCode:'B023'}                                             
				,{name: 'PRODUCT_LDTIME'    		,text:'<t:message code="unilite.msg.sMR376" default="제조 L/T"/>'        ,type : 'int'}                                                  
				,{name: 'MAX_PRODT_Q'    			,text:'<t:message code="unilite.msg.sMR377" default="최대생산량"/>'       ,type : 'uniQty'}                                                   
				,{name: 'STAN_PRODT_Q'    			,text:'<t:message code="unilite.msg.sMR378" default="표준생산량"/>'       ,type : 'uniQty'}                                                   
				,{name: 'ROUT_TYPE'    				,text:'<t:message code="unilite.msg.fsbMsgB0066" default="공정구분"/>'    ,type : 'string', store: Ext.data.StoreManager.lookup('BPR250ukrvDIV_PRSNStore') }                                                  
				,{name: 'WORK_SHOP_CODE'    		,text:'<t:message code="unilite.msg.sMR379" default="주작업장"/>'         ,type : 'string', comboType:'WU'}                                                  
				,{name: 'ITEM_TYPE'    				,text:'<t:message code="unilite.msg.sMR389" default="양산구분"/>'         ,type : 'string', comboType:'AU', comboCode:'B074'}                                                               
				
				,{name: 'ITEM_CODE2'    			,text:'<t:message code="unilite.msg.sMR004" default="품목코드"/>'         ,type : 'string'} 
				,{name: 'DIST_LDTIME'    			,text:'<t:message code="unilite.msg.sMR433" default="발주 L/T"/>'        ,type : 'int'}                                                       
				,{name: 'ATP_LDTIME'    			,text:'<t:message code="unilite.msg.sMR383" default="ATP L/T"/>'       ,type : 'int'}                                                   
				,{name: 'INSPEC_YN'    				,text:'<t:message code="unilite.msg.sMR384" default="품질대상여부"/>'     ,type : 'string', comboType:'AU', comboCode:'A020'}                                               
				,{name: 'BAD_RATE'    				,text:'<t:message code="unilite.msg.sMR385" default="불량율"/>'         ,type : 'uniPercent'}                                                         
				,{name: 'INSPEC_METH_MATRL'   		,text:'<t:message code="unilite.msg.sMR386" default="수입검사방법"/>'     ,type : 'string', comboType:'AU', comboCode:'Q005'}                                                
				,{name: 'INSPEC_METH_PROG'    		,text:'<t:message code="unilite.msg.sMR387" default="공정검사방법"/>'     ,type : 'string', comboType:'AU', comboCode:'Q006'}                                                
				,{name: 'INSPEC_METH_PRODT'   		,text:'<t:message code="unilite.msg.sMR388" default="출하검사방법"/>'     ,type : 'string', comboType:'AU', comboCode:'Q007'}  
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bpr200skrMasterStore',{
			model: 'Bpr200skrModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
	           
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 's_bpr200skrv_kdService.selectDetailList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param = Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			}
	});

	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */	
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
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
	           	defaultType: 'uniTextfield',
	           	items: [{     
							fieldLabel: '사업장', 
							name: 'DIV_CODE', 
							xtype: 'uniCombobox', 
							comboType: 'BOR120', 
							allowBlank: false,
							listeners: {
								change: function(combo, newValue, oldValue, eOpts) {
									panelResult.setValue('DIV_CODE', newValue);					
								}
							}
							},{
								fieldLabel: '계정구분', 
								name: 'ITEM_ACCOUNT', 
								xtype: 'uniCombobox', 
								comboType: 'AU', 
								comboCode: 'B020',
								listeners: {
									change: function(combo, newValue, oldValue, eOpts) {						
										panelResult.setValue('ITEM_ACCOUNT', newValue);
									}
								}
							},
							{
			        			xtype: 'uniTextfield',
					            name: 'ITEM_CODE',  		
				    			fieldLabel: '품목코드' ,
								listeners: {
									change: function(field, newValue, oldValue, eOpts) {						
										panelResult.setValue('ITEM_CODE', newValue);
									}
								}
				    		},
							{
								fieldLabel: '조달구분', 
								name: 'SUPPLY_TYPE', 
								xtype: 'uniCombobox', 
								comboType: 'AU', 
								comboCode: 'B014',
								listeners: {
									change: function(combo, newValue, oldValue, eOpts) {						
										panelResult.setValue('SUPPLY_TYPE', newValue);
									}
								}
							},{
								fieldLabel: '밸런스아웃여부', 
								name: 'B_OUT_YN', 
								xtype: 'uniCombobox', 
								comboType: 'AU', 
								comboCode: 'A020',
								listeners: {
									change: function(field, newValue, oldValue, eOpts) {						
										panelResult.setValue('B_OUT_YN', newValue);
									}
								}
							},{
								fieldLabel: '재고관리여부', 
								name: 'STOCK_CARE_YN', 
								xtype: 'uniCombobox', 
								comboType: 'AU', 
								comboCode: 'A020',
								listeners: {
									change: function(field, newValue, oldValue, eOpts) {						
										panelResult.setValue('STOCK_CARE_YN', newValue);
									}
								}
							}
					  ]
				}],
		   		setAllFieldsReadOnly: function(b) {
					var r= true
					if(b) {
						var invalid = this.getForm().getFields().filterBy(function(field) {
																			return !field.validate();
																		});
	   	
		   				if(invalid.length > 0) {
							r=false;
		   					var labelText = ''
		   	
							if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		   					}
		
						   	alert(labelText+Msg.sMB083);
						   	invalid.items[0].focus();
						} else {
							  var fields = this.getForm().getFields();
							Ext.each(fields.items, function(item) {
								if(Ext.isDefined(item.holdable) )	{
								 	if (item.holdable == 'hold') {
										item.setReadOnly(true); 
									}
								} 
								if(item.isPopupField)	{
									var popupFC = item.up('uniPopupField')	;							
									if(popupFC.holdable == 'hold') {
										popupFC.setReadOnly(true);
									}
								}
							})  
		   				}
			  		} else {
			  			var fields = this.getForm().getFields();
						Ext.each(fields.items, function(item) {
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(false);
								}
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;	
								if(popupFC.holdable == 'hold' ) {
									item.setReadOnly(false);
								}
							}
						})
	  				}
					return r;
	  			}
		    });    
		
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',		      
		        comboType:'BOR120',
				width: 325,
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '계정구분', 
				name: 'ITEM_ACCOUNT', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B020',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},
			{
		        xtype: 'uniTextfield',
				name: 'ITEM_CODE',  		
				fieldLabel: '품목코드' ,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
				     	panelSearch.setValue('ITEM_CODE', newValue);
					}
				}
			},
			{
				fieldLabel: '조달구분', 
				name: 'SUPPLY_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'B014',
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SUPPLY_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '밸런스아웃여부', 
				name: 'B_OUT_YN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'A020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('B_OUT_YN', newValue);
					}
				}
			},{
				fieldLabel: '재고관리여부', 
				name: 'STOCK_CARE_YN', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'A020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('STOCK_CARE_YN', newValue);
					}
				}
		
			}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('bpr200skrGrid', {
    	region: 'center',
        layout: 'fit',
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: false,			
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
        store: directMasterStore,
        columns:  [  { dataIndex: 'COMP_CODE',          width: 80 			, hidden: true}
					,{ dataIndex: 'ITEM_CODE',  		width: 160          , isLink:true, locked: true}
					,{ dataIndex: 'ITEM_NAME',  		width: 140          , locked: true}					
					,{ dataIndex: 'SPEC',  				width: 170          }
					
					,{ dataIndex: 'BCNT',  				width: 80           , hidden: true}
					,{ dataIndex: 'BCNT1',  			width: 80           , hidden: true}
					,{ dataIndex: 'BCNT2',  			width: 80           , hidden: true}
					,{ dataIndex: 'STOCK_UNIT',  		width: 80           , align: 'center'}
					,{ dataIndex: 'ITEM_LEVEL1',  	    width: 120}      
				    ,{ dataIndex: 'ITEM_LEVEL2',  	    width: 120}    
				    ,{ dataIndex: 'ITEM_LEVEL3',  	    width: 120} 
			
					,{ dataIndex: 'SALE_UNIT',  	    width: 120, align: 'center'}            
			  		,{ dataIndex: 'TRNS_RATE',  	    width: 80		}             
			  		,{ dataIndex: 'TAX_TYPE',  		    width: 80, align: 'center'}              
			  		,{ dataIndex: 'SALE_BASIS_P',  	    width: 120		}    
			  		
			  		,{ dataIndex: 'ITEM_ACCOUNT', 		width: 80           }
					,{ dataIndex: 'SUPPLY_TYPE',  		width: 100          }
					,{ dataIndex: 'ORDER_UNIT',  		width: 80           , align: 'center'}	

					,{ dataIndex: 'TRNS_RATE',  		width: 80           }
					,{ dataIndex: 'WH_CODE',  			width: 100          }
					,{ dataIndex: 'LOCATION',  			width: 80           , hidden: true}
					,{ dataIndex: 'ORDER_PLAN',  		width: 120          }
					,{ dataIndex: 'MATRL_PRESENT_DAY',  width: 90    		, hidden: true}
					,{ dataIndex: 'LOT_YN',  		    width: 90    }
					,{ dataIndex: 'PHANTOM_YN',  		width: 90    }
					,{ dataIndex: 'PURCHASE_BASE_P',  	width: 80      	    }
					,{ dataIndex: 'ORDER_PRSN',  		width: 100          }
					,{ dataIndex: 'ABC_FLAG',  			width: 80           , hidden: true}
					,{ dataIndex: 'EXCESS_RATE',  		width: 80           , hidden: true}
					,{ dataIndex: 'EXPENSE_RATE', 		width: 80           , hidden: true}
					
                    ,{ dataIndex: 'CAR_TYPE',  		    width: 100}
                    ,{ dataIndex: 'OEM_ITEM_CODE',      width: 110}
                    ,{ dataIndex: 'AS_ITEM_CODE',       width: 110}
                    ,{ dataIndex: 'B_OUT_YN',    	    width: 100}
                    ,{ dataIndex: 'B_OUT_DATE',  	    width: 100}
                    ,{ dataIndex: 'MAKE_STOP_YN',       width: 100}
                    ,{ dataIndex: 'MAKE_STOP_DATE',     width: 100}
                    ,{ dataIndex: 'AUTO_EXAM_YN',       width: 100}
                    ,{ dataIndex: 'DEPT_GUBUN',         width: 100}
					,{ text: 'MRP정보'
			    	  ,columns:[
								 { dataIndex: 'ORDER_KIND',  		width: 100   }
								,{ dataIndex: 'NEED_Q_PRESENT',  	width: 100   }
								,{ dataIndex: 'EXC_STOCK_CHECK_YN', width: 100   }
								,{ dataIndex: 'SAFE_STOCK_Q',  		width: 100   }
								,{ dataIndex: 'NEED_Q_PRESENT_Q',  	width: 100   }
							  ]
					 }
					,{ text: '구매정보'
			    	  ,columns:[
								 { dataIndex: 'PURCH_LDTIME',  		width: 80    }
								,{ dataIndex: 'MINI_PURCH_Q',  		width: 90    }
								,{ dataIndex: 'MAX_PURCH_Q',  		width: 90    }
								,{ dataIndex: 'COMP_CODE',  		width: 80    , hidden: true}
								,{ dataIndex: 'CUSTOM_NAME',  		width: 130   }
							]
					}
					,{ dataIndex: 'ROP_YN',  			width: 100           , hidden: true}
					,{ dataIndex: 'DAY_AVG_SPEND',  	width: 80       	 , hidden: true}
					,{ dataIndex: 'ORDER_POINT',  		width: 80         	 , hidden: true}
					,{ dataIndex: 'BASIS_P',  			width: 80            , hidden: true}
					,{ dataIndex: 'COST_YN',  			width: 80            , hidden: true}
					,{ dataIndex: 'COST_PRICE',  		width: 80            , hidden: true}
					,{ dataIndex: 'REAL_CARE_YN',  		width: 80        	 , hidden: true}
					,{ dataIndex: 'REAL_CARE_PERIOD',  	width: 80    		 , hidden: true}
					,{ dataIndex: 'MINI_PACK_Q',  		width: 80         	 , hidden: true}
										
					,{ text: '생산정보'
			    	  ,columns:[		
				  				 { dataIndex: 'ORDER_METH',  		width: 90   }
								,{ dataIndex: 'OUT_METH',  			width: 90   }
								,{ dataIndex: 'RESULT_YN',  		width: 90   }
								,{ dataIndex: 'PRODUCT_LDTIME',  	width: 80   }
								,{ dataIndex: 'MAX_PRODT_Q',  		width: 90   }
								,{ dataIndex: 'STAN_PRODT_Q',  		width: 90   }
								,{ dataIndex: 'ROUT_TYPE',  		width: 90   }
								,{ dataIndex: 'WORK_SHOP_CODE',  	width: 130  }
								,{ dataIndex: 'ITEM_TYPE',  		width: 80   , hidden: true}
					  ]
					}
					,{ text: '품질정보'
			    	  ,columns:[
								 { dataIndex: 'INSPEC_YN',  		width: 90    }
								,{ dataIndex: 'BAD_RATE',  			width: 80    }
								,{ dataIndex: 'INSPEC_METH_MATRL',  width: 110   }
								,{ dataIndex: 'INSPEC_METH_PROG',  	width: 110   }
								,{ dataIndex: 'INSPEC_METH_PRODT',  width: 110   , hidden: true}
							  ]
					}
				]
    });   
	
    Unilite.Main({
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            	masterGrid, panelResult
	     	]
	     },
	         panelSearch
	    ], 
		id  : 'bpr200skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
							
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
					
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function()	{			
			if(!this.isValidSearchForm()){
				return false;
			}
			
			masterGrid.getStore().loadStoreRecords();
			
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			
			this.fnInitBinding();
		}
	});
};


</script>
