<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="str410ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="str410ukrv" /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 수불담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B086" /> <!-- 전자문서구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S050" /> <!-- 상태 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var BsaCodeInfo = {
	gsOptQ: '${gsOptQ}',
	gsOptP: '${gsOptP}',
	gsBillYN: ${gsBillYN}
};
var isOptQ = false; //수량단위구분, 단가금액출력여부
if(BsaCodeInfo.gsOptQ == "2" || BsaCodeInfo.gsOptP == "2"){
	isOptQ = true;	
}

var beforeRowIndex;		//마스터그리드 같은row중복 클릭시 다시 load되지 않게
//console.log(BsaCodeInfo.gsOptQ + '\n' +BsaCodeInfo.gsOptP + '\n' + BsaCodeInfo.gsBillYN[0].REF_CODE4+ '/' + BsaCodeInfo.gsBillYN[0].REF_CODE9 );

function appMain() {     
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'str410ukrvService.selectDetail',
            update: 'str410ukrvService.updateDetail',
            create: 'str410ukrvService.insertDetail',
            destroy: 'str410ukrvService.deleteDetail',
            syncAll: 'str410ukrvService.saveAll'
        }
    });
	
	/**
	 *   Model 정의 
	 * @type 
	 */    			
	Unilite.defineModel('Str410ukrvModel1', {
	    fields: [  	 
			{name: 'TRANSYN_NAME'		    ,text: '전송'						    ,type: 'string'},  	 
			{name: 'STS'           	       	,text: '상태'						    ,type: 'string'},  	 
			{name: 'DT'		       	       	,text: '<t:message code="system.label.sales.issuedate" default="출고일"/>'					        ,type: 'uniDate'},  	 
			{name: 'CUSTOM_CODE'		    ,text: '<t:message code="system.label.sales.client" default="고객"/>'					    ,type: 'string'},  	 
			{name: 'RCOMPANY'			    ,text: '<t:message code="system.label.sales.clientname" default="고객명"/>'					        ,type: 'string'},  	 
			{name: 'RVENDERNO'			    ,text: '사업자번호'				        ,type: 'string'},  	 
			{name: 'INOUT_PRSN_NM' 	       	,text: '<t:message code="system.label.sales.trancharge" default="수불담당"/>'					    ,type: 'string'},  	 
			{name: 'SUPMONEY'      	       	,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'					    ,type: 'uniPrice'},  	 
			{name: 'TAXMONEY'			    ,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'						    ,type: 'uniPrice'},  	 
			{name: 'TOT_AMT_I'   		    ,text: '<t:message code="system.label.sales.totalamount" default="합계"/>'						    ,type: 'uniPrice'},  	 
			{name: 'SEND_DATE'			    ,text: '전송일시'					    ,type: 'uniDate'},  	 
			{name: 'BILLSEQ'			    ,text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'					    ,type: 'string'},  	 
			{name: 'REMAIL'				    ,text: 'E-MAIL'					        ,type: 'string'},  	 
			{name: 'EB_NUM'      		    ,text: '전자문서번호'				    ,type: 'string'},  	 
			{name: 'CREATE_DT'     	       	,text: '생성일자'					    ,type: 'uniDate'},  	 
			{name: 'TRANSYN'			    ,text: '전송여부'					    ,type: 'string'},  	 
			{name: 'TAXRATE'       	       	,text: '세율구분'					    ,type: 'string'},  	 
			{name: 'BILLTYPE'      	       	,text: 'BILLTYPE'				        ,type: 'string'},  	 
			{name: 'CASH'          	       	,text: '거래명세서상의 현금지급액'		,type: 'uniPrice'},  	 
			{name: 'CHECKS'        	       	,text: '거래명세서상의 수표지급액'		,type: 'uniPrice'},  	 
			{name: 'NOTE'          	       	,text: '거래명세서상의 어음지급액'		,type: 'uniPrice'},  	 
			{name: 'CREDIT'        	       	,text: '거래명세서상의 외상미수금'		,type: 'uniPrice'},  	 
			{name: 'GUBUN'         	       	,text: '영수/청구 구분'				    ,type: 'string'},  	 
			{name: 'BIGO'          	       	,text: '<t:message code="system.label.sales.remarks" default="비고"/>'						    ,type: 'string'},  	 
			{name: 'SVENDERNO'     	       	,text: '공급자 사업자번호'			    ,type: 'string'},  	 
			{name: 'SCOMPANY'      	       	,text: '공급자 업체명'				    ,type: 'string'},  	 
			{name: 'SCEONAME'      	       	,text: '공급자 대표자명'				,type: 'string'},  	 
			{name: 'SUPTAE'        	       	,text: '공급자 업태'				    ,type: 'string'},  	 
			{name: 'SUPJONG'       	       	,text: '공급자 업종'				    ,type: 'string'},  	 
			{name: 'SADDRESS'      	       	,text: '공급자 주소'				    ,type: 'string'},  	 
			{name: 'SADDRESS2'     	       	,text: '공급자 상세주소'				,type: 'string'},  	 
			{name: 'SUSER'         	       	,text: '공급자 담당자명'				,type: 'string'},  	 
			{name: 'SDIVISION'     	       	,text: '공급자 부서명'				    ,type: 'string'},  	 
			{name: 'STELNO'        	       	,text: '공급자 전화번호'				,type: 'string'},  	 
			{name: 'SEMAIL'        	       	,text: '공급자 이메일주소'			    ,type: 'string'},  	 
			{name: 'RCEONAME'      	       	,text: '공급받는자 대표자명'			,type: 'string'},  	 
			{name: 'RUPTAE'        	       	,text: '공급받는자 업태'				,type: 'string'},
			{name: 'RUPJONG'       	       	,text: '공급받는자 업종'				,type: 'string'},  	 
			{name: 'RADDRESS'      	       	,text: '공급받는자 주소'				,type: 'string'},  	 
			{name: 'RADDRESS2'     	       	,text: '공급받는자 상세주소'			,type: 'string'},  	 
			{name: 'RUSER'         	       	,text: '공급받는자 담당자명'			,type: 'string'},  	 
			{name: 'RDIVISION'     	       	,text: '공급받는자 부서명'			    ,type: 'string'},  	 
			{name: 'RTELNO'        	       	,text: '공급받는자 전화번호'			,type: 'string'},  	 
			{name: 'REVERSEYN'     	       	,text: '역발행여부'				        ,type: 'string'},  	 
			{name: 'SENDID'        	       	,text: '공급자'					        ,type: 'string'},  	 
			{name: 'RECVID'        	       	,text: '공급받는자'				        ,type: 'string'},  	 
			{name: 'COMP_CODE'     	       	,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'					    ,type: 'string'},  	 
			{name: 'DIV_CODE'      	       	,text: '<t:message code="system.label.sales.divisioncode" default="사업장코드"/>'				        ,type: 'string'},  	 
			{name: 'INOUT_PRSN'   		    ,text: '<t:message code="system.label.sales.trancharge" default="수불담당"/>'					    ,type: 'string'},  	 
			{name: 'DEL_YN'        	       	,text: '삭제가능여부'				    ,type: 'string'},  	 
			{name: 'BILL_MEM_TYPE' 	       	,text: '회원구분'					    ,type: 'string'}
		]
	});
	Unilite.defineModel('Str410ukrvModel2', {
	    fields: [ 			
			{name: 'DT'			 	       	,text: '출고일자'					,type: 'uniDate'},
			{name: 'CODE'		 	       	,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string'},
			{name: 'NAME'		 	       	,text: '<t:message code="system.label.sales.item" default="품목"/>'						,type: 'string'},
			{name: 'UNIT'		 	       	,text: '<t:message code="system.label.sales.spec" default="규격"/>'						,type: 'string'},
			{name: 'VLM'		 	       	,text: '<t:message code="system.label.sales.qty" default="수량"/>'						,type: 'uniQty'},
			{name: 'DANGA'		 	       	,text: '<t:message code="system.label.sales.price" default="단가"/>'						,type: 'uniPrice'},
			{name: 'SUP'		 	       	,text: '<t:message code="system.label.sales.supplyamount" default="공급가액"/>'					,type: 'uniPrice'},
			{name: 'TAX'		 	       	,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'						,type: 'uniPrice'},
			{name: 'COMP_CODE'	 	       	,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'					,type: 'string'},
			{name: 'DIV_CODE'	 	       	,text: '<t:message code="system.label.sales.division" default="사업장"/>'					    ,type: 'string'},
			{name: 'INOUT_NUM'	 	       	,text: '<t:message code="system.label.sales.issueno" default="출고번호"/>'					,type: 'string'},
			{name: 'INOUT_SEQ'	 	       	,text: '<t:message code="system.label.sales.seq" default="순번"/>'						,type: 'int'},
			{name: 'ITEM_CODE'	 	       	,text: '<t:message code="system.label.sales.item" default="품목"/>'					,type: 'string'},
			{name: 'CUSTOM_CODE' 	       	,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				    ,type: 'string'},
			{name: 'SALE_UNIT'	 	       	,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>'					,type: 'string', displayField: 'value'},
			{name: 'TRANS_RATE'	 	       	,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'						,type: 'uniQty'}
		]  
	});		//End of Unilite.defineModel('Str410ukrvModel', {
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	
	var masterStore = Unilite.createStore('str410ukrvMasterStore',{
			model: 'Str410ukrvModel1',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'str410ukrvService.selectMaster'                	
                }
            },
            loadStoreRecords: function()	{
				var param= panelSearch.getValues();			
				console.log( param );
				this.load({
					params: param
				});			
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		if(!Ext.isEmpty(records)){
	           			detailStore.loadStoreRecords(records[0]);
	           			var viewNormal = detailGrid.getView();
						console.log("viewNormal : ",viewNormal);
						viewNormal.getFeature('detailGridTotal').toggleSummaryRow(true);	 
	           		}else{
	           			detailStore.removeAll('clear');           		
	           		}
	           	}
			}
	});		// End of var masterStore = Unilite.createStore('str410ukrvMasterStore',{
	
	var detailStore = Unilite.createStore('str410ukrvDetailStore',{
			model: 'Str410ukrvModel2',
			uniOpt: {
            	isMaster: true,			    // 상위 버튼 연결 
            	editable: true,			    // 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false				// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
            loadStoreRecords : function(record){
				var gridParam = record.data; 
				var formParam = {};
				formParam.UNIT_TYPE = panelSearch.getField('UNIT_TYPE').getValue() ? '1' : '2';
				formParam.PRINT_TYPE = panelSearch.getField('PRINT_TYPE').getValue() ? '1' : '2';
				
				var params = Ext.merge(gridParam, formParam);
				this.load({
					//params : record.data
					params : params
				});				
			},
            saveStore: function() {             
                var inValidRecs = this.getInvalidRecords();
                var toCreate = this.getNewRecords();
                var toUpdate = this.getUpdatedRecords();                
                var toDelete = this.getRemovedRecords();
                var list = [].concat(toUpdate, toCreate);
                console.log("inValidRecords : ", inValidRecs);
                console.log("list:", list);
    
                var inoutNum = panelSearch.getValue('INOUT_NUM');
                Ext.each(list, function(record, index) {
                    if(record.data['INOUT_NUM'] != inoutNum) {
                        record.set('INOUT_NUM', inoutNum);
                    }
                })
                console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
                
                //1. 마스터 정보 파라미터 구성
                var paramMaster= panelSearch.getValues();    //syncAll 수정
                if(inValidRecs.length == 0) {
                    config = {
                        params: [paramMaster],
                        success: function(batch, option) {
                            //2.마스터 정보(Server 측 처리 시 가공)
                        /*  var master = batch.operations[0].getResultSet();
                            panelSearch.setValue("INOUT_NUM", master.INOUT_NUM);
                            */
                            //3.기타 처리
                            panelSearch.getForm().wasDirty = false;
                            panelSearch.resetDirtyStatus();
                            console.log("set was dirty to false");
                            UniAppManager.setToolbarButtons('save', false);     
                        } 
                    };
                    this.syncAllDirect(config);
                } else {
                    var grid = Ext.getCmp('str410ukrvDetailGrid');
                    grid.uniSelectInvalidColumnAndAlert(inValidRecs);
                }
            },
			listeners: {
	           	load: function(store, records, successful, eOpts) {
						          		
	           	}
			}
	});		// End of var detailStore = Unilite.createStore('str410ukrvDetailStore',{

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
 	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',      
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
        listeners: {
            collapse: function () {
                panelResult.show();
            },
            expand: function() {
                panelResult.hide();
            }
        },
        items: [{   
            title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',  
            itemId: 'search_panel1',
            layout: {type: 'uniTable', columns: 1},
            defaultType: 'uniTextfield',            
            items: [{
    				fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
    				name:'DIV_CODE',
    				xtype: 'uniCombobox',
    				comboType:'BOR120',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
    			},{
    	        	fieldLabel: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
    	        	xtype: 'uniDateRangefield',
    	        	startFieldName: 'INOUT_DATE_FR',
    	        	endFieldName: 'INOUT_DATE_TO',
    	        	width: 315,
    	        	startDate: UniDate.get('today'),
    	        	endDate: UniDate.get('today'),                   
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('INOUT_DATE_FR', newValue);                       
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('INOUT_DATE_TO', newValue);                           
                        }
                    }
    			},
    				Unilite.popup('AGENT_CUST',{ 
    					fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>', 
                        valueFieldName: 'CUSTOM_CODE', 
                        textFieldName: 'CUSTOM_NAME', 
    					validateBlank: false, 
                        listeners: {
                            onSelected: {
                                fn: function(records, type) {
                                    panelResult.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));
                                    panelResult.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));                                                                                                           
                                },
                                scope: this
                            },
                            onClear: function(type) {
                                panelResult.setValue('CUSTOM_CODE', '');
                                panelResult.setValue('CUSTOM_NAME', '');
                            }
                        }
    				}),
    			{
    				fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
    				name:'INOUT_PRSN',
    				xtype: 'uniCombobox',
    				comboType:'AU',
    				comboCode:'B024',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('INOUT_PRSN', newValue);
                        }
                    }
    			},{
    				fieldLabel: '전자문서구분',
    				name:'BILL_TYPE',
    				xtype: 'uniCombobox',
    				comboType:'AU',
    				comboCode:'B086',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('BILL_TYPE', newValue);
                        }
                    }
    			},{
    				xtype: 'radiogroup',		            		
    				fieldLabel: '전송여부',
    				items: [{
    					boxLabel: '미전송', 
    					width:80, 
    					name: 'BILL_SEND_YN', 
    					inputValue: 'N', 
    					checked: true
    				},{
    					boxLabel: '전송', 
    					width:80, 
    					name: 'BILL_SEND_YN', 
    					inputValue: 'Y'
    				}],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.getField('BILL_SEND_YN').setValue(newValue.BILL_SEND_YN);
                        }
                    } 
    			},{
    				fieldLabel: '상태',
    				name:'BILL_STAT',
    				xtype: 'uniCombobox',
    				comboType:'AU',
    				comboCode:'S050',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('BILL_STAT', newValue);
                        }
                    }
    			},{					
        			fieldLabel: '에러내용',
        			name:'ERROR',
        			xtype: 'textareafield',
        			width: 315,
        			height: 35,
        			readOnly: true,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('ERROR', newValue);
                        }
                    }
        		},{
        			xtype: 'container',
        			html: '<hr></hr>'
        		},{
    				xtype: 'radiogroup',		            		
    				fieldLabel: '수량단위구분',	
    				items: [{
    					boxLabel: '<t:message code="system.label.sales.salesunit" default="판매단위"/>', 
    					width:80, 
    					name: 'UNIT_TYPE', 
    					inputValue: '1', 
    					checked: !isOptQ
    				},{
    					boxLabel: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>', 
    					width:80, 
    					name: 'UNIT_TYPE', 
    					inputValue: '2',
    					checked: isOptQ
    				}],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.getField('UNIT_TYPE').setValue(newValue.UNIT_TYPE);
                        }
                    } 
    			},{
    				xtype: 'radiogroup',		            		
    				fieldLabel: '단가금액출력',
    				items: [{
    					boxLabel: '예', 
    					width:80, 
    					name: 'PRINT_TYPE', 
    					inputValue: '1', 
    					checked: true
    				},{
    					boxLabel: '아니오', 
    					width:80, 
    					name: 'PRINT_TYPE', 
    					inputValue: '2'
    				}],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelResult.getField('PRINT_TYPE').setValue(newValue.PRINT_TYPE);
                        }
                    } 
    			},{
    				xtype:'container',
    				margin: '0 0 0 16',
    				layout: {type: 'uniTable', columns: 2},
    				style: {
    					color: 'blue'				
    				},
    				items:[{
    					xtype: 'container',
    					html: '※&nbsp;</br></br></br>'					
    				}, {
    					xtype: 'container',
    					html: '공급자는 사업장정보, 공급받는자는 거래처정보에서 회사</br>명, 대표자, 업태, 업종, 주소, 전화번호, EMAIL 등을 참조</br>합니다.'				
    				}]
    				
    			}
        	]
		}]
    });		// End of var panelSearch = Unilite.createSearchForm('searchForm',{ 
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
                fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'INOUT_DATE_FR',
                endFieldName: 'INOUT_DATE_TO',
                width: 315,
                colspan: 2,
                startDate: UniDate.get('today'),
                endDate: UniDate.get('today'),                   
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('INOUT_DATE_FR', newValue);                       
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('INOUT_DATE_TO', newValue);                           
                    }
                }
            },
                Unilite.popup('AGENT_CUST',{ 
                    fieldLabel: '<t:message code="system.label.sales.client" default="고객"/>', 
                    valueFieldName: 'CUSTOM_CODE', 
                    textFieldName: 'CUSTOM_NAME', 
                    validateBlank: false, 
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelSearch.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
                                panelSearch.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));                                                                                                           
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelSearch.setValue('CUSTOM_CODE', '');
                            panelSearch.setValue('CUSTOM_NAME', '');
                        }
                    }
                }),
            {
                fieldLabel: '<t:message code="system.label.sales.trancharge" default="수불담당"/>',
                name:'INOUT_PRSN',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'B024',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('INOUT_PRSN', newValue);
                    }
                }
            },{
                fieldLabel: '전자문서구분',
                name:'BILL_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'B086',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('BILL_TYPE', newValue);
                    }
                }
            },{
                xtype: 'radiogroup',                            
                fieldLabel: '전송여부',
                items: [{
                    boxLabel: '미전송', 
                    width:80, 
                    name: 'BILL_SEND_YN', 
                    inputValue: 'N', 
                    checked: true
                },{
                    boxLabel: '전송', 
                    width:80, 
                    name: 'BILL_SEND_YN', 
                    inputValue: 'Y'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.getField('BILL_SEND_YN').setValue(newValue.BILL_SEND_YN);
                    }
                } 
            },{
                fieldLabel: '상태',
                name:'BILL_STAT',
                xtype: 'uniCombobox',
                comboType:'AU',
                colspan: 2,
                comboCode:'S050',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('BILL_STAT', newValue);
                    }
                }
            },{                 
                fieldLabel: '에러내용',
                name:'ERROR',
                xtype: 'textareafield',
                width: 315,
                height: 35,
                colspan: 3,
                readOnly: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('ERROR', newValue);
                    }
                }
            },{
                xtype: 'container',
                colspan: 3,
                html: '<hr></hr>'
            },{
                xtype: 'radiogroup',                            
                fieldLabel: '수량단위구분',   
                items: [{
                    boxLabel: '<t:message code="system.label.sales.salesunit" default="판매단위"/>', 
                    width:80, 
                    name: 'UNIT_TYPE', 
                    inputValue: '1', 
                    checked: !isOptQ
                },{
                    boxLabel: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>', 
                    width:80, 
                    name: 'UNIT_TYPE', 
                    inputValue: '2',
                    checked: isOptQ
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.getField('UNIT_TYPE').setValue(newValue.UNIT_TYPE);
                    }
                } 
            },{
                xtype: 'radiogroup',                            
                fieldLabel: '단가금액출력',
                colspan: 3,
                items: [{
                    boxLabel: '예', 
                    width:80, 
                    name: 'PRINT_TYPE', 
                    inputValue: '1', 
                    checked: true
                },{
                    boxLabel: '아니오', 
                    width:80, 
                    name: 'PRINT_TYPE', 
                    inputValue: '2'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelSearch.getField('PRINT_TYPE').setValue(newValue.PRINT_TYPE);
                    }
                } 
            },{
                xtype:'container',
                margin: '0 0 0 16',
                layout: {type: 'uniTable', columns: 2},
                style: {
                    color: 'blue'               
                },
                items:[{
                    xtype: 'container',
                    html: '※공급자는 사업장정보, 공급받는자는 거래처정보에서 회사명, 대표자, 업태, 업종, 주소, 전화번호, EMAIL 등을 참조합니다.'                  
                }]
                
            }
        ],
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
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }

//                  Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');    중복알림 금지
                    invalid.items[0].focus();
                } else {
                    //this.mask();
//                  var fields = this.getForm().getFields();
//                  Ext.each(fields.items, function(item) {
//                      if(Ext.isDefined(item.holdable) ){
//                          if (item.holdable == 'hold') {
//                              item.setReadOnly(true); 
//                          }
//                      } 
//                      if(item.isPopupField)   {
//                          var popupFC = item.up('uniPopupField')  ;                           
//                          if(popupFC.holdable == 'hold') {
//                              popupFC.setReadOnly(true);
//                          }
//                      }
//                  })
                }
            } else {
                //this.unmask();
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false); 
                        }
                    } 
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;   
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;       
        }       
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid= Unilite.createGrid('str410ukrvMasterGrid', {
        layout:'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: true,
			onLoadSelectFirst: false,
			useRowNumberer: false
        },
    	store: masterStore,
    	features: [{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],    	
        selModel: Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: true,
        	toggleOnClick: false,
        	listeners: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {//Error컬럼은 선택 못하게
        			if(record.get('TRANSYN_NAME') == 'Error'){
						return false;        			        				
        			}
        		},
				select: function(grid, record, index, eOpts ){					
					
	          	},
				deselect:  function(grid, record, index, eOpts ){					
        		}
        	}
        }),
        columns:  [
        	{dataIndex:'TRANSYN_NAME'		    , width: 60,locked: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '총합계', '총합계');
                }
        	},
        	{dataIndex:'STS'           	     	, width: 60,locked: true},
        	{dataIndex:'DT'		       	     	, width: 86,locked: true},
        	{dataIndex:'CUSTOM_CODE'		    , width: 86,locked: true},
        	{dataIndex:'RCOMPANY'			    , width: 160,locked: true},
        	{dataIndex:'RVENDERNO'			    , width: 100},
        	{dataIndex:'INOUT_PRSN_NM' 	     	, width: 86,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
    			       return Unilite.renderSummaryRow(summaryData, metaData, '건수 : ' + masterStore.getCount() +  '건', metaData, '건수 : ' + masterStore.getCount() +  '건');
                }
        	
				/*summaryRenderer: function(value, summaryData, dataIndex ) {
              		var	rv =  "<div align='center'>건수 : " + masterStore.getCount() + " 건</div>";		                	
            		return rv;										
	            }*/
        	},
        	{dataIndex:'SUPMONEY'      	     	, width: 113, summaryType: 'sum'},
        	{dataIndex:'TAXMONEY'			    , width: 86, summaryType: 'sum'},
        	{dataIndex:'TOT_AMT_I'   		    , width: 113, summaryType: 'sum'},
        	{dataIndex:'SEND_DATE'			    , width: 146},
        	{dataIndex:'BILLSEQ'			    , width: 133},
        	{dataIndex:'REMAIL'				    , width: 100},
        	{dataIndex:'EB_NUM'      		    , width: 86},
        	{dataIndex:'CREATE_DT'     	     	, width: 33, hidden:true},
        	{dataIndex:'TRANSYN'			    , width: 100, hidden:true},
        	{dataIndex:'TAXRATE'       	     	, width: 33, hidden:true},
        	{dataIndex:'BILLTYPE'      	     	, width: 33, hidden:true},
        	{dataIndex:'CASH'          	     	, width: 33, hidden:true},
        	{dataIndex:'CHECKS'        	     	, width: 33, hidden:true},
        	{dataIndex:'NOTE'          	     	, width: 33, hidden:true},
        	{dataIndex:'CREDIT'        	     	, width: 33, hidden:true},
        	{dataIndex:'GUBUN'         	     	, width: 33, hidden:true},
        	{dataIndex:'BIGO'          	     	, width: 33, hidden:true},
        	{dataIndex:'SVENDERNO'     	     	, width: 33, hidden:true},
        	{dataIndex:'SCOMPANY'      	     	, width: 33, hidden:true},
        	{dataIndex:'SCEONAME'      	     	, width: 33, hidden:true},
        	{dataIndex:'SUPTAE'        	     	, width: 33, hidden:true},
        	{dataIndex:'SUPJONG'       	     	, width: 33, hidden:true},
        	{dataIndex:'SADDRESS'      	     	, width: 33, hidden:true},
        	{dataIndex:'SADDRESS2'     	     	, width: 33, hidden:true},
        	{dataIndex:'SUSER'         	     	, width: 33, hidden:true},
        	{dataIndex:'SDIVISION'     	     	, width: 33, hidden:true},
        	{dataIndex:'STELNO'        	     	, width: 33, hidden:true},
        	{dataIndex:'SEMAIL'        	     	, width: 33, hidden:true},
        	{dataIndex:'RCEONAME'      	     	, width: 33, hidden:true},
        	{dataIndex:'RUPTAE'        	     	, width: 33, hidden:true},
        	{dataIndex:'RUPJONG'       	     	, width: 33, hidden:true},
        	{dataIndex:'RADDRESS'      	     	, width: 33, hidden:true},
        	{dataIndex:'RADDRESS2'     	     	, width: 33, hidden:true},
        	{dataIndex:'RUSER'         	     	, width: 33, hidden:true},
        	{dataIndex:'RDIVISION'     	     	, width: 33, hidden:true},
        	{dataIndex:'RTELNO'        	     	, width: 33, hidden:true},
        	{dataIndex:'REVERSEYN'     	     	, width: 33, hidden:true},
        	{dataIndex:'SENDID'        	     	, width: 33, hidden:true},
        	{dataIndex:'RECVID'        	     	, width: 33, hidden:true},
        	{dataIndex:'COMP_CODE'     	     	, width: 33, hidden:true},
        	{dataIndex:'DIV_CODE'      	     	, width: 33, hidden:true},
        	{dataIndex:'INOUT_PRSN'   		    , width: 86, hidden:true},
        	{dataIndex:'DEL_YN'        	     	, width: 33, hidden:true},
        	{dataIndex:'BILL_MEM_TYPE' 	     	, width: 33, hidden:true}


        ],
        tbar: [{	////전송버튼들 로직 만들어야함.
	    	itemId : 'submitBtn', iconCls : 'icon-referance'	,
			text:'전송',
			handler: function() {
				
			}
       	}, {
       		itemId : 'reSubmitBtn', iconCls : 'icon-referance'	,
			text:'재전송',
			handler: function() {
				
			}
       	}, {
       		itemId : 'cancelSubmitBtn', iconCls : 'icon-referance'	,
			text:'전송취소',
			handler: function() {
				
			}
       	}],
        
		listeners: {
//			beforecellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//				return view.getSelectionModel().isSelected();
//			},
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				if(rowIndex != beforeRowIndex){
					detailStore.loadStoreRecords(record);
				}
				beforeRowIndex = rowIndex;
//				var selModel = view.getSelectionModel();
//				if(selModel.isSelected()){
//          			detailStore.loadStoreRecords(record);
//				}
				
   		  	////ROW더블클릭시 출고등록으로 데이터 전송및 조회되게 하는 부분 해야함.
   		  	////row클릭시 선택된 row색깔 표시 되야함.
   		  	////전송 부분이ERROR일시 쿼리타고 ERROR코드 가져오는 로직 처리 해야함.
			}
       }             
    });
    
    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
	var detailGrid= Unilite.createGrid('str410ukrvDetailGrid', {
		layout:'fit',
        region:'south',
        uniOpt: {
			expandLastColumn: true
        },
    	store: detailStore,
    	features: [{
    		id: 'detailGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns:  [
        	{dataIndex:'DT'			     , width:100,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '총합계', '총합계');
            }
            },
        	{dataIndex:'CODE'		     , width:233,hidden:true},
        	{dataIndex:'NAME'		     , width:233,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '건수 : ' + masterStore.getCount() +  '건', metaData, '건수 : ' + masterStore.getCount() +  '건');
            }
				
				/*summaryRenderer: function(value, summaryData, dataIndex ) {
              		var	rv =  "<div align='center'>건수 : " + detailStore.getCount() + " 건</div>";		                	
            		return rv;										
	           }*/
	        },
        	{dataIndex:'UNIT'		     , width:133},
        	{dataIndex:'VLM'		     , width:120, summaryType: 'sum'},
        	{dataIndex:'DANGA'		     , width:120},
        	{dataIndex:'SUP'		     , width:133, summaryType: 'sum'},
        	{dataIndex:'TAX'		     , width:120, summaryType: 'sum'},
        	{dataIndex:'COMP_CODE'	     , width:66,hidden:true},
        	{dataIndex:'DIV_CODE'	     , width:66,hidden:true},
        	{dataIndex:'INOUT_NUM'	     , width:66,hidden:true},
        	{dataIndex:'INOUT_SEQ'	     , width:66,hidden:true},
        	{dataIndex:'ITEM_CODE'	     , width:66,hidden:true},
        	{dataIndex:'CUSTOM_CODE'     , width:66,hidden:true},
        	{dataIndex:'SALE_UNIT'	     , width:66,hidden:true},
        	{dataIndex:'TRANS_RATE'	     , width:66,hidden:true}
    	], 
        listeners: {              
            beforeedit: function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['NAME', 'UNIT']))
                    {
                        return true;
                    } else {
                        return false;
                    }
            }
        }
	});		// End of var detailGrid= Unilite.createGrid('str410ukrvDetailGrid', {
    
    Unilite.Main({ 

        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, detailGrid, panelResult
            ]
        },
            panelSearch     
        ],
		id: 'str410ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.getField('INOUT_DATE_FR').focus();		
			////권한에 따른 사업장 diplayYN 해야함
			/*
			If gsAuParam(0) <> "N" Then
			cboDivCode.disabled = True
			btnDivCode.disabled = True
			End If
			*/
		},
		onQueryButtonDown: function()	{		
			masterGrid.getStore().loadStoreRecords();
			beforeRowIndex = -1;
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);			
			
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);			
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);	
		},
        onSaveDataButtonDown: function(config) {                        
            detailStore.saveStore();
            
        }	
	});		// End of Unilite.Main({
};
</script>
