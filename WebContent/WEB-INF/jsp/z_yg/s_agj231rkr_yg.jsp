<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_agj231rkr_yg"  >
		<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	/*var masterStore = Unilite.createStore('hum970rkrMasterStore',{
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
	        //비고(*) 사용않함
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'hum970rkrService.fnHum970nQ1'                	
            }
        }, //(사용 안 함 : 쿼리에서 처리)
        listeners : {
	        load : function(store) {
	            if (store.getCount() > 0) {
	            	setGridSummary(true);
	            } else {
	            	setGridSummary(false);
	            }
	        }
	    },
		loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	}); //End of var masterStore = Unilite.createStore('hum970rkrMasterStore',{
*/

/*	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
				xtype: 'radiogroup',		            		
				fieldLabel: '출력선택',						            		
				id: 'optPrintGb',
				labelWidth: 90,
				items: [
				{
					boxLabel: '월별인원현황분석표', 
					width: 170, 
					name: 'optPrint',
					inputValue: '0',
					checked: true  
				},
                {
					boxLabel: '부서별인원현황분석표', 
					width: 160, 
					name: 'optPrint',
					inputValue: '1'
				},
				{
					boxLabel: '부서별인원현황분석표(연속)', 
					width: 190, 
					name: 'optPrint',
					inputValue: '2'
				}],
				listeners: {
					change: function(radiogroup, newValue, oldValue, eOpts) {	 
					}
				}
			}]
	});	*/
	
    var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'west',
		layout : {type : 'uniTable', columns : 1
		},
		padding:'1 1 1 1',
		border:true,
		items: [
			   {
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				id : 'DIV_CODE',
				xtype: 'uniCombobox',
		        //multiSelect: true, 
		        //typeAhead: false,
		        comboType:'BOR120',
				width: 230,
		        allowBlank: true
			},{ 
    			fieldLabel: '집계일',
                name: 'START_DATE',
                xtype: 'uniDatefield',
                allowBlank:true,
                width:230
	        },{
	           fieldLabel:'현금', 
                xtype: 'uniNumberfield',
                name: 'C_STOCK', 
                value: '' ,
                width: 230
           }
           ,{
               fieldLabel:'어음', 
                xtype: 'uniNumberfield',
                name: 'U_UM',
                value: '' ,
                width: 230
           }
           ,{
               fieldLabel:'전일잔고(통장)', 
                xtype: 'uniNumberfield',
                name: 'TLT_AMT', 
                value: '' ,
                width: 230
           }
           ,{
               fieldLabel:'전일잔고(현금)', 
                xtype: 'uniNumberfield',
                name: 'LC_AMT', 
                value: '' ,
                width: 230
           }
           ,{
               fieldLabel:'금일잔고(통장)', 
                xtype: 'uniNumberfield',
                name: 'CT_AMT', 
                value: '' ,
                width: 230
           }
           ,{
               fieldLabel:'자동이체', 
                xtype: 'uniNumberfield',
                name: 'AT_AMT', 
                value: '' ,
                width: 230
           }
           ,{
               fieldLabel:'현재시재액', 
                xtype: 'uniNumberfield',
                name: 'CC_AMT',
                value: '' ,
                width: 230
           }
           ,{
               fieldLabel:'일련번호', 
                xtype: 'uniTextfield',
                name: 'SEAL_NUM', 
                value: '' ,
                width: 230
           },{ 
                fieldLabel: '결산일',
                name: 'CALC_DATE',
                xtype: 'uniDatefield',
                value: '' ,
                width:230
            }
           ,{
	         	xtype:'button',
	         	text:'출    력',
	         	width:235,
	         	tdAttrs:{'align':'left', style:'padding-left:95px'},
	         	handler:function()	{
	         		UniAppManager.app.onPrintButtonDown();
	         	}
	     }]
	});		
	
	Unilite.Main({
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				//panelResult, panelResult2
				panelResult
			]	
		}		
		], 
		id: 's_agj231rkr_ygApp',
		fnInitBinding : function() {
			
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
			//panelResult.setValue('START_DATE',getStDt[0].STDT);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
    		panelResult.setValue('START_DATE',UniDate.get('today'));
			
		},
        onPrintButtonDown: function() {
        	
        	var title_Doc = '';
        	var dRsCount = 0;
        	var dSumAmt  = 0;

            title_Doc = '지출집계표'; 

			var param1  = Ext.getCmp('resultForm').getValues();
			
			s_agj231rkr_ygService.selectPrintList1(param1, function(provider, response) {
                  if(!Ext.isEmpty(provider)){
                              	
                  dRsCount = provider[0].recordcnt;
                  dSumAmt = provider[0].sum_amt;
                  
                  } else {
                  	
                  dRsCount = 0;
                  dSumAmt = 0;
                  
                  }
                  
            var formValues  = panelResult.getValues();
            

                  //현금
                var vStock = '';
                var cStock = 0;
                vStock = panelResult.getValue('C_STOCK');
                       
                   if (Ext.isEmpty(vStock)) {
                    cStock      = 0;
                   } else {
                    cStock      = formValues.C_STOCK;
                   }
                   
                //어음
                var vUum = '';
                var uUm = '';
                vlTamt = panelResult.getValue('U_UM');
                       
                   if (Ext.isEmpty(vlTamt)) {
                    uUm      = 0;
                   } else {
                    uUm      = formValues.U_UM;
                   }
                   
                //전일잔고(통장)
                var vLtamt = '';
                var lTamt = '';
                vLtamt = panelResult.getValue('TLT_AMT');
                       
                   if (Ext.isEmpty(vLtamt)) {
                    lTamt      = 0;
                   } else {
                    lTamt      = formValues.TLT_AMT;
                   }
                   
                //전일잔고(현금)
                var vLcamt = '';
                var lcamt = '';
                vLcamt = panelResult.getValue('LC_AMT');
                       
                   if (Ext.isEmpty(vLcamt)) {
                    lcamt      = 0;
                   } else {
                    lcamt      = formValues.LC_AMT;
                   }
                   
                //금일잔고(통장)
                var vCtamt = '';
                var cTamt = '';
                vCtamt = panelResult.getValue('CT_AMT');
                       
                   if (Ext.isEmpty(vCtamt)) {
                    cTamt      = 0;
                   } else {
                    cTamt      = formValues.CT_AMT;
                   }
                   
                //자동이체
                var vAtamt = '';
                var aTamt = '';
                vAtamt = panelResult.getValue('AT_AMT');
                       
                   if (Ext.isEmpty(vAtamt)) {
                    aTamt      = 0;
                   } else {
                    aTamt      = formValues.AT_AMT;
                   }
                   
                //현재시재액
                var vCcamt = '';
                var cCamt = '';
                vCcamt = panelResult.getValue('CC_AMT');
                       
                   if (Ext.isEmpty(vCcamt)) {
                    cCamt      = 0;
                   } else {
                    cCamt      = formValues.CC_AMT;
                   }
                   
                //일련번호
                var vSealNum = '';
                var sEalNum = '';
                vSealNum = panelResult.getValue('SEAL_NUM');
                       
                   if (Ext.isEmpty(vSealNum)) {
                    sEalNum      = 'WXY';
                   } else {
                    sEalNum      = formValues.SEAL_NUM;
                   }
                   
                //결산일
                var vCalcDate = '';
                var cAlcDate = '';
                vCalcDate = panelResult.getValue('CALC_DATE');
                       
                   if (Ext.isEmpty(vCalcDate)) {
                    cAlcDate      = '29991231';
                   } else {
                    cAlcDate      = formValues.CALC_DATE;
                   }
                
                var param = {
                       
                       DIV_CODE     : formValues.DIV_CODE,                               // bParam(0)  : 사업장
                       START_DATE   : formValues.START_DATE,                             // bParam(1)  : 집계일
                       
                       C_STOCK      : cStock  ,                             // bParam(2)  : 현금
                       U_UM         : uUm,                                   // bParam(3)  : 어음
                       TLT_AMT       : lTamt,                                 // bParam(4)  : 전일잔고(통장)
                       LC_AMT       : lcamt,                                 // bParam(5)  : 전일잔고(현금)
                       CT_AMT       : cTamt,                                 // bParam(6)  : 금일잔고(통장)
                       AT_AMT       : aTamt,                                 // bParam(7)  : 자동이체
                       
                       CC_AMT       : cCamt,                                 // bParam(8)  : 현재시재액
                       SEAL_NUM     : sEalNum,                               // bParam(9)  : 일련번호
                       CALC_DATE    : cAlcDate,                              // bParam(10) : 결산일
                       
                       RS_COUNT     : dRsCount,                              // 집계건수
                       SUM_AMT      : dSumAmt,                               // 신청금맥
    
                       
                       // 레포트로 파라미터 넘기기 매개변수 (조회와 관련 없음)
                       TITLE          : title_Doc,                                   // 제목
                       COMP_NAME      : UserInfo.divCode                             //회사명
    
                }
                
                var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/z_yg/s_agj231crkr_yg.do',
                    prgID: 's_agj231crkr_yg',
                    extParam: param
                });
                win.center();
                win.show();
                  
                  
                  
			});
			
			
                    
			/*var bParam = {
//				   DOC_KIND		: Ext.getCmp('optPrintGb').getChecked()[0].inputValue,		  // bParam(0) // 증명서 종류 
				   DOC_KIND		: Ext.getCmp('optPrintGb').getValue().optPrint,		  // bParam(0) // 증명서 종류 
						// 재직증명서 : 1 , 퇴직증명서 : 2, 경력증명서 : 0, 증명서 대장 : 3
				   PERSON_NUMB  	: param2.PERSON_NUMB,  										  // bParam(1)
				   ISS_DATE 		: param2.ISS_DATE,	   										  // bParam(2)
				   PROF_NUM		: param2.PROF_NUM,	   										  // bParam(3)
				   ANN_FR_DATE   : param2.ANN_FR_DATE,  						                  // bParam(4)
				   ANN_TO_DATE	: param2.ANN_TO_DATE,   									  // bParam(5)
				   //bParam(6) = mid(goCnn.GetUi("FDAY"),5,1)         
				   DIV_CODE		: param2.DIV_CODE,	   										  // bParam(7)
				   COMP_CODE     : UserInfo.compCode,	  									  // bParam(8)  도장이미지 포함
				   SYS_DATE		: UniDate.getDbDateStr(UniDate.get('today')).substring(0, 4), // bParam(9)
				   ENCRYPT		: Ext.getCmp('rdoEncrypt').getChecked()[0].inputValue, 		  // bParam(10) 암호화
				   
				   // 레포트로 파라미터 넘기기 매개변수 (조회와 관련 없음)
				   TITLE			: title_Doc,		// 제목
				   TEXT          : text_Doc, 		// 내용
				   SEQ_COUNT		: param2.SEQ_FR + "  " + Msg.sMH1225 + "  /  " + param2.SEQ_TO + "  " + Msg.sMH1225, // 신청통수 
				   USE           : param2.USE		// 용도
			}*/
			/*hum970rkrService.fnHum970nQ(bParam, function(provider, response){			// 증명번호 최신화
				if(!Ext.isEmpty(provider)  && provider == true){
					var win = Ext.create('widget.PDFPrintWindow', {
			            url: CPATH+'/hum/hum970rkrPrint.do',
			            prgID: prgID1,
			            extParam: bParam
		            });
		            win.center();
		            win.show();
		            
		            if(win.show){		// fnUpdateChanges() 넣는 곳
		            	if(doc_Kind != '3'){
		            		UniAppManager.app.fnUpdateChanges();
		            	}
		            }
		          
				}
			});*/
	        
	    },
/*		onResetButtonDown: function() {
			panelResult.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		}*/
	    fnHum970FileExist: function() {
	    	
	    	
	    },
	    fnUpdateChanges : function() {
	    	
	    }
	}); //End of 	Unilite.Main( {
	
};

</script>
