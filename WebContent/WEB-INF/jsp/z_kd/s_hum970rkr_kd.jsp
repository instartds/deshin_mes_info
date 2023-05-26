<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hum970rkr_kd"  >
		<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var certi_Num = ''; // 증명번호 마지막 번호

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

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
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
					boxLabel: '경력증명서', 
					width: 120, 
					name: 'optPrint',
					inputValue: '0'
//					checked: true  
				},
                {
					boxLabel: '재직증명서', 
					width: 120, 
					name: 'optPrint',
					inputValue: '1' ,
					checked: true
				},
				{
					boxLabel: '퇴직증명서', 
					width: 120, 
					name: 'optPrint',
					inputValue: '2'
				},
				{
					boxLabel: '증명서대장', 
					width: 120, 
					name: 'optPrint',
					inputValue: '3',
					//disabled :true
					hidden : true
					
				}],
				listeners: {
					change: function(radiogroup, newValue, oldValue, eOpts) {	
//                        alert(Ext.getCmp('optPrintGb').getValue().optPrint);

						//증명번호 가져오기
						var param = {"S_COMP_CODE": UserInfo.compCode,
						              "CERTI_TYPE": newValue.optPrint};      
                        s_hum970rkr_kdService.fnHum970ini(param, function(provider, response){           // 증명번호 최신화
                            if(!Ext.isEmpty(provider)){
                                panelResult2.setValue('PROF_NUM' , provider);
                            }
                        });
						
						
//						if(Ext.getCmp('optPrintGb').getChecked()[0].inputValue == '3') {
						if(Ext.getCmp('optPrintGb').getValue().optPrint == '3') {
							Ext.getCmp('PERSON_NUMB').setReadOnly(true);
							Ext.getCmp('DIV_CODE').setReadOnly(true);
							Ext.getCmp('DATE').setReadOnly(true);
						} else {
							Ext.getCmp('PERSON_NUMB').setReadOnly(false);
							Ext.getCmp('DIV_CODE').setReadOnly(false);
							Ext.getCmp('DATE').setReadOnly(false);
						}
					},
	    			onTextSpecialKey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	panelResult2.getField('NAME').focus();  
	                	}
	                }
				}
			}]
	});	
	
    var panelResult2 = Unilite.createSearchForm('resultForm2',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'west',
		layout : {type : 'uniTable', columns : 1
		},
		padding:'1 1 1 1',
		border:true,
		items: [
			Unilite.popup('Employee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				allowBlank: false,
				id : 'PERSON_NUMB', 
				listeners: {
					'onSelected': {
						fn: function(records, type) {
							panelResult2.setValue('PERSON_NUMB', records[0].PERSON_NUMB);
	                    	panelResult2.setValue('NAME', 		 records[0].NAME);
	                    	panelResult2.setValue('DIV_CODE',	 records[0].DIV_CODE);
	                    	panelResult2.setValue('ANN_FR_DATE', records[0].JOIN_DATE);
	                    	panelResult2.setValue('RETR_DATE'  , records[0].RETR_DATE);
	                    	//RETR_DATE
	                    	
	                    	if(records[0].RETR_DATE == '' || records[0].RETR_DATE == '00000000'){
	                    		panelResult2.setValue('ANN_TO_DATE', UniDate.get('today'));
	                    	}else{
	                    		panelResult2.setValue('ANN_TO_DATE', records[0].RETR_DATE);
	                    	}
						},
						scope: this
					},
					'onClear': function(type) {
						panelResult2.setValue('PERSON_NUMB','');
                    	panelResult2.setValue('NAME','');
                    	panelResult2.setValue('DIV_CODE','');
                    	panelResult2.setValue('ANN_FR_DATE','');
                    	panelResult2.setValue('ANN_TO_DATE','');
                    	panelResult2.setValue('RETR_DATE','');
					},
					applyextparam: function(popup){	
						popup.setExtParam({'BASE_DT': '00000000'}); 
						popup.setExtParam({'PAY_GUBUN': '1'}); 
					}
 				}
			}),{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				id : 'DIV_CODE',
				xtype: 'uniCombobox',
		        //multiSelect: true, 
		        //typeAhead: false,
		        comboType:'BOR120',
				//width: 325,
		        allowBlank: false
			},{ 
    			fieldLabel: '근무기간',
		        xtype: 'uniDateRangefield',
		        id : 'DATE',
		        startFieldName: 'ANN_FR_DATE',
		        endFieldName: 'ANN_TO_DATE',
		        width: 325,
		        allowBlank: false
	        },{
				fieldLabel: '증명번호',
				name:'PROF_NUM',
				xtype: 'uniTextfield',
				allowBlank: false
			},{
		 		fieldLabel: '발급일',
		 		xtype: 'uniDatefield',
		 		name: 'ISS_DATE',
		 		value: UniDate.get('today'),
		 		allowBlank: false
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:600,
				items :[{
					fieldLabel:'신청통수', 
					xtype: 'uniTextfield',
					name: 'SEQ_FR', 
					width:198
				},{
					xtype:'component', 
					html:'/',
					style: {
				        marginTop: '3px !important',
				        font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				    }
				},{
	 				fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'SEQ_TO', 
					width:113
				}]
			},{
			 	fieldLabel: '용도',
			 	xtype: 'uniTextfield',
			 	name: 'USE',
			 	width: 405
			},{
			 	fieldLabel: '퇴직사유',
			 	xtype: 'uniTextfield',
			 	name: 'RETR_TEXT',
			 	width: 405
			},{
				xtype: 'radiogroup',	
				id: 'rdoEncrypt',
				fieldLabel: '주민번호 암호화',	
				labelWidth: 90,
				items: [{
					boxLabel: '한다', 
					width: 50, 
					name: 'rdoEncrypt',
					inputValue: 'Y',
					checked: true  
				},{
					boxLabel: '안한다',  
					width: 70, 
					name: 'rdoEncrypt',
					inputValue: 'N'
				}]
			},{
                fieldLabel: '퇴직일',
                name:'RETR_DATE',
                xtype: 'uniTextfield', 
                hidden : true
            },{
				margin:'15 0 0 20',
				xtype:'container',
				html: '<b>※ 주의사항</b>',
				style: {
					color: 'blue'				
				}
			},{
				xtype:'container',
				html: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 인쇄버튼을 클릭하시면 실제 인쇄여부에 관계 없이 증명번호가 카운트 되니 </br>' +
					  '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 이점 유의하시어 사전에 미리보기로 충분히 검토하신 후에 인쇄를 실행하여</br> ' +
					  '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 주시기 바랍니다.',
				style: {
					color: 'blue'				
				}
			},{
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
				panelResult, panelResult2
			]	
		}		
		], 
		id: 's_hum970rkr_kdApp',
		fnInitBinding : function() {
			
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
			
//			var param = {"S_COMP_CODE": UserInfo.compCode };
			var param = {"S_COMP_CODE": UserInfo.compCode,
                                      "CERTI_TYPE": '1'}; //재직증명서 inputValue 강제지정
			hum970rkrService.fnHum970ini(param, function(provider, response){			// 증명번호 최신화
				if(!Ext.isEmpty(provider)){
					panelResult2.setValue('PROF_NUM' , provider);
				}
			});
		},
        onPrintButtonDown: function() {
        	        	
        	//panelResult2.getValue('ANN_FR_DATE');
        	
        	UniAppManager.app.fnHum970FileExist();  // 도장이미지 존재여부
        	
//        	var doc_Kind = Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
        	var doc_Kind = Ext.getCmp('optPrintGb').getValue().optPrint;
        	var printChk = panelResult2.getValue('RETR_DATE');
        	
        	if(doc_Kind == '1'){
        	   if(printChk != '' || printChk == '00000000'){
        	   	   Ext.Msg.alert("확인","퇴직 한 사원은 재직증명서를 발급할 수 없습니다.");
        	       return false;
        	   }
        	}
        	
        	if(doc_Kind == '2'){
               if(printChk == ''){
                    Ext.Msg.alert("확인","현재 재직 중인 사원은 퇴직증명서를 발급할 수 없습니다.");
                    return false;                   
               }
            }
        	
        	if(doc_Kind != '3'){
	        	if(!panelResult2.getInvalidMessage()) return;   
        	}
			
			var annFrDate = panelResult2.getValue('ANN_FR_DATE');
			var annToDate = panelResult2.getValue('ANN_TO_DATE');
			annFrDate = UniDate.getDbDateStr(annFrDate);
			annToDate = UniDate.getDbDateStr(annToDate);
			
			if( annFrDate > annToDate ){		// 근무기간 Check
				return false;
			}	
			
			
			var title_Doc = '';
			var text_Doc  = '';
			var use_Doc   = '';
			var retr_text = '';
						
			if(doc_Kind == '1' ){
				title_Doc = '( 재 직 ) 증 명 서'; 
				text_Doc  = '위의 사실을 증명함';
				//text_Doc  = Msg.sMH1223; // 재직중임을 증명하여 주시기 바랍니다.
				//prgID1    = 'hum970rkr';
			}else if(doc_Kind == '2'){
				title_Doc = '( 퇴 직 ) 증 명 서'; 
				text_Doc  = '위의 사실을 증명함';
				//text_Doc  = Msg.sMH1224;	// 재직하였음을 증명하여 주시기 바랍니다.
				//prgID1 	  = 'hum970rkr';
			}
			else if(doc_Kind == '0'){
				title_Doc = '( 경 력 ) 증 명 서'; 
				text_Doc  = '위의 사실을 증명함';
				//text_Doc  = 'empty';
				//prgID1    = 'hum970rkr';
			}
			else if(doc_Kind == '3'){
				title_Doc = ' 증명서 대장'; 
				text_Doc  = 'empty';
				//prgID1    = 'hum971rkr';
				//prgID1    = 'hum970rkr';
			}
			
			var param  = Ext.getCmp('resultForm').getValues();			// 상단 증명서 종류
			var param2 = Ext.getCmp('resultForm2').getValues();			// 하단 검색조건 
			
			if(Ext.isEmpty(param2.USE)){
			 use_Doc = 'empty';
			} else {
			 use_Doc = param2.USE;
			}
			
			if (param2.RETR_TEXT == ''){
				retr_text = 'empty';
			} else {
				retr_text = param2.RETR_TEXT;
			}
			
			
			var param = {
                   DOC_KIND     : Ext.getCmp('optPrintGb').getValue().optPrint,                     // bParam(0) // 증명서 종류 
                   // 경력증명서 : 0, 재직증명서 : 1 , 퇴직증명서 : 2,  증명서 대장 : 3
                   PERSON_NUMB      : param2.PERSON_NUMB,                                           // bParam(1)
                   ISS_DATE         : param2.ISS_DATE,                                              // bParam(2)
                   PROF_NUM         : param2.PROF_NUM,                                              // bParam(3)
                   ANN_FR_DATE      : param2.ANN_FR_DATE,                                           // bParam(4)
                   ANN_TO_DATE      : param2.ANN_TO_DATE,                                           // bParam(5) 
                   DIV_CODE         : param2.DIV_CODE,                                              // bParam(7)
                   COMP_CODE        : UserInfo.compCode,                                            // bParam(8)  도장이미지 포함
                   SYS_DATE         : UniDate.getDbDateStr(UniDate.get('today')).substring(0, 4),   // bParam(9)
                   ENCRYPT          : Ext.getCmp('rdoEncrypt').getChecked()[0].inputValue,          // bParam(10) 암호화
                   
                   // 레포트로 파라미터 넘기기 매개변수 (조회와 관련 없음)
                   TITLE            : title_Doc,        // 제목
                   TEXT             : text_Doc,         // 내용
                   SEQ_COUNT        : param2.SEQ_FR + "  " + Msg.sMH1225 + "  /  " + param2.SEQ_TO + "  " + Msg.sMH1225, // 신청통수 
                   USE              : use_Doc,        // 용도
                   RETR_TEXT        : retr_text        // 퇴직사유
            }
			
			var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/z_kd/s_hum970crkr_kd.do',
                prgID: 's_hum970crkr_kd',
                extParam: param
            });
            win.center();
            win.show();
            
            if(doc_Kind != '3'){
                UniAppManager.app.fnUpdateChanges();
            }
                    
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
	    	// fnUpdateChanges()
	    	var param  = Ext.getCmp('resultForm2').getValues();			 
//	    	var param  = Ext.getCmp('resultForm').getValues();			// 상단 증명서 종류 
	    	
//	    	var bParam0 = Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
	    	var bParam0 = Ext.getCmp('optPrintGb').getValue().optPrint;
	    	
	    	
	    	
	    	
	    	var bParam4 = '1' // 한글
	    	
	    	if(bParam0 == '1'){
	    		bParam0 = '1';
	    	}else if(bParam0 == '2'){
	    		bParam0 = '2';
	    	}else{
	    		bParam0 = '0';
	    	}
	    	
//	    	param.optPrintGb = bParam0;
	    	param.optPrint = bParam0;
	    	
	    	
	    	param.bParam4    = bParam4;

	    	hum970rkrService.insertDetail(param, function(provider, response){	
	    		hum970rkrService.fnHum970ini(param, function(provider2, response){
					if(!Ext.isEmpty(provider2)){
						panelResult2.setValue('PROF_NUM', provider2);
					}	
	    		});
			});
	    }
	}); //End of 	Unilite.Main( {
	
	
	Unilite.createValidator('validator01', {
		forms: {'formA:':panelResult2},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "SEQ_FR" : // 신청통수 FR
					if(isNaN(newValue))	{
	            	 	alert(Msg.sMB074);	//숫자만 입력 가능합니다.
	            	 	return;
						break;
	            	}
	            	break;
	           case "SEQ_TO" : // 신청통수 TO
					if(isNaN(newValue))	{
	            	 	alert(Msg.sMB074);	//숫자만 입력 가능합니다.
	            	 	return;
						break;
	            	} 	
				break;
			}
			return rv;
		}
	}); // validator
};

</script>
