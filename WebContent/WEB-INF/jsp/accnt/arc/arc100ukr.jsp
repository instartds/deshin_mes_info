<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="arc100ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="J501" /> <!-- 채권구분 -->
	<t:ExtComboStore comboType="AU" comboCode="J502" /> <!-- 이관취소사유 -->
	<t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="J504" /> <!-- 관리구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A134" /> <!-- 결재상태 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
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


var SAVE_FLAG = '';
var personName   = '${personName}';

var requestFlag = '';

var BsaCodeInfo = { 
    requestURL: '${appv_popup_url}'
};
var gsWin;
function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'arc100ukrService.selectList',
			update: 'arc100ukrService.updateDetail',
			create: 'arc100ukrService.insertDetail',
			destroy: 'arc100ukrService.deleteDetail',
			syncAll: 'arc100ukrService.saveAll'
		}
	});	
	
	var directProxyRequest = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'arc100ukrService.insertRequestDetail',
			syncAll: 'arc100ukrService.saveRequestAll'
		}
	});	
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('arc100ukrModel', {
	    fields: [
//	    	{name: ''			,text: 'NO'					,type: 'string'},
	    	{name: 'MNG_DATE'			,text: '일자'					,type: 'string'},
	    	{name: 'MNG_GUBUN'			,text: '관리구분'					,type: 'string'},
	    	{name: 'REMARK'				,text: '내용'					,type: 'string'},
	    	{name: 'RECEIVE_AMT'		,text: '접수금액'					,type: 'uniPrice'},
	    	{name: 'COLLECT_AMT'		,text: '수금액'					,type: 'uniPrice'},
	    	{name: 'NOTE_NUM'			,text: '어음번호'					,type: 'string'},
	    	{name: 'EXP_DATE'			,text: '만기일'					,type: 'uniDate'},
	    	{name: 'DRAFTER'			,text: '입력자'					,type: 'string'}
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore = Unilite.createStore('arc100ukrDetailStore', {
		model: 'arc100ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			allDeletable:false,
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
            type: 'direct',
            api: {
            	read: 'arc100ukrService.selectList'                	
            }
        },
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
	});	
	
	var requestButtonStore = Unilite.createStore('Arc100ukrRequestButtonStore',{		
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		proxy: directProxyRequest,
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
//			var toCreate = branchStore.data.items;
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
//       		var paramList = branchStore.data.items;
			var paramMaster = panelResult.getValues();	//syncAll 수정
//			param.FR_INPUT_DATE = UniDate.getDbDateStr(panelSearch.getValue('FR_INPUT_DATE'));
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						
						UniAppManager.app.onQueryButtonDown();
//						,,,,,,,,,,
					/*	panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		*/
						
					/*	if(panelResult.getValue('BRANCH_OPR_FLAG') == 'B' || panelResult.getValue('BRANCH_OPR_FLAG') == 'C'){
							UniAppManager.updateStatus(Msg.fsbMsgB0076);
						}else if(panelResult.getValue('BRANCH_OPR_FLAG') == 'R'){
							UniAppManager.updateStatus(Msg.fSbMsgA0526);
						}
						
						panelResult.setValue('BRANCH_OPR_FLAG', '');
						UniAppManager.app.onQueryButtonDown();*/
					 },
					 failure: function(batch, option) {
					 
					 	
					 	
					 }
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('arc100ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	
    var detailForm = Unilite.createForm('resultForm',{
//		split:true,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3,
			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'}
//        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
	
		},
		padding:'1 1 1 1',
		border:true,
		disabled:false,
		items: [{
	 		xtype: 'uniDatefield',
	 		fieldLabel: '등록일',
	 		name: 'RECE_DATE',
	 		value: UniDate.get('today'),
	 		allowBlank:false
    	},
		Unilite.popup('Employee',{
			fieldLabel: '작성자', 
			valueFieldWidth: 90,
			textFieldWidth: 140,
			valueFieldName:'DRAFTER',
		    textFieldName:'DRAFTER_NAME',
		    readOnly: true
		}),	
		{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:'100%',
			margin: '0 0 0 0',
			tdAttrs: {align : 'right'},
			items :[{
	    		xtype: 'button',
	    		text: '결재요청',
	    		id:'btnRequest',
	    		name: '',
	    		width: 80,	
	    		tdAttrs: {align : 'center'},
				handler : function() {
					if(Ext.isEmpty(detailForm.getValue('RECE_NO'))){
						Ext.Msg.alert('확인','결재요청 처리할 데이터가 없습니다.');
					}else if(detailForm.getValue('GW_STATUS') != '0'){
						Ext.Msg.alert('확인','이미 결재요청 되었습니다.</br>'+ '상태 : '+ detailForm.getField("GW_STATUS").rawValue);
					}else{
    					var param = {
                            RECE_NO: detailForm.getValue('RECE_NO')
                        }
                        var param2 = {
                           RECE_NO: detailForm.getValue('RECE_NO'),
                           GW_RECE_NO : "2" + UserInfo.compCode + "17" + detailForm.getValue('RECE_NO') 
                        }
    //                detailForm.getEl().mask(' 중...','loading-indicator');
                        
                        if(confirm('그룹웨어에 반드시 로그인이 되어 있어야합니다.\n계속 하시겠습니까?')) {
                        
                            arc100ukrService.beforeCheckRequest(param, function(provider, response)  {                           
                                if(!Ext.isEmpty(provider)){   
                                    if(provider[0].GW_STATUS != '0'){
                                        alert("이미 결재요청 되었습니다.\n상태 : "+ provider[0].CODE_NAME);
                                    }else{
                                        arc100ukrService.beforeUpdateRequest(param2, function(provider, response)  {
                                        	if(provider){  
                                        		var winWidth=1000;
                                                var winHeight=600;
                                                
                                                var scrW=screen.availWidth;
                                                var scrH=screen.availHeight;
                                                
                                                var positionX=(scrW-winWidth)/2;
                                                var positionY=(scrH-winHeight)/2;
                            
                                                if(Ext.isEmpty(gsWin)){
                                                    gsWin = window.open('about:blank','cardviewer','left='+positionX+',top='+positionY+',width='+winWidth+',height='+winHeight+'');
                                                }
                                                var requestMsg = '<?xml version="1.0" encoding="euc-kr" ?>';
                                                requestMsg = requestMsg + '<aprv APPID="WF_BOND_TR_REQ">';
                                                requestMsg = requestMsg + '<item>';
                                                requestMsg = requestMsg + '<apprManageNo>'+ UserInfo.compCode + "17" + detailForm.getValue('RECE_NO') +'</apprManageNo>';
                                                requestMsg = requestMsg + '</item>';
                                                requestMsg = requestMsg + '<content><![CDATA[';
                                                requestMsg = requestMsg + '<table style="border-collapse:collapse; border:1px gray solid;">';
                                                requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + '거래처';
                                                requestMsg = requestMsg + '</td>';
                                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + detailForm.getValue('CUSTOM_NAME');
                                                requestMsg = requestMsg + '</td>';
                                                requestMsg = requestMsg + '</tr>';
                                                requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + '금액';
                                                requestMsg = requestMsg + '</td>';
                                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + Ext.util.Format.number(detailForm.getValue('RECE_AMT'),'0,000') + ' 원';
                                                requestMsg = requestMsg + '</td>';
                                                requestMsg = requestMsg + '</tr>';
                                                requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + '대표자';
                                                requestMsg = requestMsg + '</td>';
                                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + detailForm.getValue('TOP_NAME');
                                                requestMsg = requestMsg + '</td>';
                                                requestMsg = requestMsg + '</tr>';
                                                requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + '주소';
                                                requestMsg = requestMsg + '</td>';
                                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + detailForm.getValue('ADDR');
                                                requestMsg = requestMsg + '</td>';
                                                requestMsg = requestMsg + '</tr>';
                                                requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + '연락처';
                                                requestMsg = requestMsg + '</td>';
                                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + detailForm.getValue('PHONE_1')+'-'+detailForm.getValue('PHONE_2')+'-'+detailForm.getValue('PHONE_3');
                                                requestMsg = requestMsg + '</td>';
                                                requestMsg = requestMsg + '</tr>';
                                                requestMsg = requestMsg + '<tr style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + '비고';
                                                requestMsg = requestMsg + '</td>';
                                                requestMsg = requestMsg + '<td style="border:1px gray solid;padding: 5px 10px;">';
                                                requestMsg = requestMsg + detailForm.getValue('REMARK');
                                                requestMsg = requestMsg + '</td>';
                                                requestMsg = requestMsg + '</tr>';
                                                requestMsg = requestMsg + '</table>';
                                                requestMsg = requestMsg + ']]></content>';
                                                requestMsg = requestMsg + '</aprv>';
                            
                                                console.log(requestMsg);
                                                document.getElementById("fmbd").value = requestMsg;
                                                
                                                var frm = document.f1;
                                                frm.action = BsaCodeInfo.requestURL;
                                                frm.target ="cardviewer";
                                                frm.method ="post";
                                                frm.submit();
                                                
                                                
                                                requestFlag = 'Y';
                                                detailForm.setValue('GW_STATUS','1');
                                                requestFlag = '';
    //                                            UniAppManager.app.onQueryButtonDown();
                                            }
                                        });
                                    }
                                }
                                detailForm.getEl().unmask();  
                            });
                        }else{
                            return false;
                        }
					}
				}
	    	}]
		},{
		    xtype: 'uniTextfield',
		    fieldLabel:'채권번호', 
		    name: 'RECE_NO', 
		    readOnly:true
	   },{
		    xtype: 'uniNumberfield',
		    fieldLabel:'금액',
		    name: 'RECE_AMT',
		    allowBlank:false
	   },{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:'100%',
			margin: '0 0 0 0',
			tdAttrs: {align : 'right'},
			items :[{
	    		xtype: 'button',
	    		text: '복사',
	    		id:'btnCopy',
	    		name: '',
	    		width: 80,	
	    		tdAttrs: {align : 'center'},
				handler : function() {
					if(detailForm.getValue('RECE_NO') == ''){
						return false;
					}else{
//						detailForm.clearForm();
						subForm1.clearForm();
						detailGrid.reset();
						directDetailStore.clearData();
						
						detailForm.setValue('RECE_NO','');
						detailForm.setValue('RECE_DATE',UniDate.get('today'));
						detailForm.setValue('GW_STATUS','0');
						detailForm.setValue('CANCEL_REASON','');
						
						UniAppManager.setToolbarButtons('save', true);
						SAVE_FLAG = '';
					}
				}
	    	}]
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:500,
//			id:'tdPayDtlNo',
			tdAttrs: {width:500/*align : 'center'*/},
			items :[
				Unilite.popup('CUST',{
					fieldLabel: '거래처', 
					valueFieldName:'CUSTOM_CODE',
				    textFieldName:'CUSTOM_NAME',
				    allowBlank:false,
				    listeners: {
				    	onSelected: {
							fn: function(records, type) {
								detailForm.setValue('COMPANY_NUM', records[0]["COMPANY_NUM"]);
								detailForm.setValue('TOP_NAME', records[0]["TOP_NAME"]);
								detailForm.setValue('ADDR', records[0]["ADDR1"]);
								detailForm.setValue('PHONE_1', records[0]["TELEPHON"]);
								detailForm.setValue('ZIP_CODE', records[0]["ZIP_CODE"]);
								
		                	},
							scope: this
						},
						onClear: function(type)	{
							detailForm.setValue('COMPANY_NUM', '');
							detailForm.setValue('TOP_NAME', '');
							detailForm.setValue('ADDR', '');
							detailForm.setValue('PHONE_1', '');
							detailForm.setValue('ZIP_CODE', '');
						}
					}
				}),
			{
				xtype:'uniTextfield',
				name:'COMPANY_NUM',
				width:125,
				readOnly:true
			}]		
		},{
			xtype: 'uniCombobox',
			fieldLabel: '채권구분',
			name:'RECE_GUBUN',	
		    comboType:'AU',
			comboCode:'J501',
		    allowBlank:false
		},{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:'100%',
            margin: '0 0 0 0',
            tdAttrs: {align : 'right'},
            items :[{
                xtype: 'button',
                text: '기안중취소',
                id:'btnCancel',
                name: '',
                width: 80,  
                tdAttrs: {align : 'center'},
                handler : function() {
                    if(Ext.isEmpty(detailForm.getValue('RECE_NO'))){
                        Ext.Msg.alert('확인','기안중취소 처리할 데이터가 없습니다.');
                    }else{
                        var param = {
                            RECE_NO: detailForm.getValue('RECE_NO')
                        }
                        Ext.getCmp('pageAll').getEl().mask('작업 중...','loading-indicator');
                        arc100ukrService.updateDC(param, function(provider, response)  {                           
                            if(!Ext.isEmpty(provider)){
                            	alert(response.result);
                                
                            }else{
                            	UniAppManager.updateStatus(Msg.sMB014);   
                                UniAppManager.app.onQueryButtonDown();
                            }
                            
                        Ext.getCmp('pageAll').getEl().unmask();  
                        });
                    }
                }
            }]
        },{
			xtype:'uniTextfield',
			fieldLabel:'대표자',
			name:'TOP_NAME',
			width:450
		},{
			xtype: 'uniCombobox',
			fieldLabel: '결재상태',
			name:'GW_STATUS',	
		    comboType:'AU',
			comboCode:'A134',
			colspan:2,
			readOnly:true
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 2},
			width:500,
//			id:'tdPayDtlNo',
			tdAttrs: {width:500/*align : 'center'*/},
			items :[
				Unilite.popup('ZIP',{
					fieldLabel: '주소',
					showValue:false,
					textFieldWidth:130,	
					textFieldName:'ZIP_CODE',
					DBtextFieldName:'ZIP_CODE',
					validateBlank:false,
					popupHeight:580,
					listeners: { 
						'onSelected': {
							fn: function(records, type  ){
								detailForm.setValue('ADDR', records[0]['ZIP_NAME']+records[0]['ADDR2']);
		                    },
						scope: this
						},
						'onClear' : function(type)	{
							detailForm.setValue('ADDR', '');
						}
					}
				}),
			{
			
				xtype:'uniTextfield',
			 	name:'ADDR',
			 	width:225
//			 	margin:'0 0 0 115'
			}]		
		},{
			xtype:'uniTextfield',
			fieldLabel:'비고',
			name:'REMARK',
			width:450,
			colspan:2
		},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:500,
//			id:'tdPayDtlNo',
			tdAttrs: {width:500/*align : 'center'*/},
			items :[{
				xtype:'uniTextfield',
				fieldLabel:'연락처1/2/3',
				name:'PHONE_1',
				width:220
			},{
				xtype:'uniTextfield',
				name:'PHONE_2',
				width:115
			},{
				xtype:'uniTextfield',
				name:'PHONE_3',
				width:115
			}]		
		},{
			xtype: 'uniCombobox',
			fieldLabel: '이관취소사유',
			name:'CANCEL_REASON',	
		    comboType:'AU',
			comboCode:'J502',
			width:450,
			colspan:2,
			readOnly:true
		}],
		api: {
	 		load: 'arc100ukrService.selectForm'	,
	 		submit: 'arc100ukrService.syncMaster'	
		},
        listeners : {
            uniOnChange:function( basicForm, dirty, eOpts ) {
                console.log("onDirtyChange");
                if(basicForm.isDirty()) {
                	if(requestFlag == 'Y'){
                        UniAppManager.setToolbarButtons('save', false);
                	}else{ 
                	   	UniAppManager.setToolbarButtons('save', true);
                	}
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
            }
        }
	});
    var subForm1 = Unilite.createSimpleForm('resultForm2',{
		region: 'north',
    	border:true,
//    	split:true,
	    items: [{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:500,
			tdAttrs: {align : 'center'},
			items :[{
				xtype:'component',
				html:'[이관 및 진행 정보]',
				componentCls : 'component-text_green',
				tdAttrs: {align : 'left'},
	    		width: 150,
	    		colspan:3
			},{
	    		xtype:'uniDatefield',
	    		fieldLabel:'이관일',
	    		name:'CONF_RECE_DATE',
	    		readOnly:true
	    	},{
	    		xtype:'uniNumberfield',
	    		fieldLabel:'금액',
	    		name:'TOT_RECEIVE_AMT',
	    		labelWidth: 265,
	    		readOnly:true
	    	},{
	    		xtype:'uniNumberfield',
	    		fieldLabel:'수금액',
	    		name:'TOT_COLLECT_AMT',
	    		readOnly:true
	    	},{
	    		xtype:'uniTextfield',
	    		fieldLabel:'이관채권번호',
	    		name:'CONF_RECE_NO',
	    		readOnly:true
	    	},{
	    		xtype:'uniNumberfield',
	    		fieldLabel:'조정',
	    		name:'TOT_ADJUST_AMT',
	    		labelWidth: 265,
	    		readOnly:true
	    	},{
	    		xtype:'uniNumberfield',
	    		fieldLabel:'잔액',
	    		name:'TOT_BALANCE_AMT',
	    		readOnly:true
	    	},{
				xtype: 'uniCombobox',
				fieldLabel: '진행상태',
				name:'MNG_GUBUN',	
			    comboType:'AU',
				comboCode:'J504',
				readOnly:true
			},{
	    		xtype:'uniNumberfield',
	    		fieldLabel:'대손처리',
	    		name:'TOT_DISPOSAL_AMT',
	    		labelWidth: 265,
	    		readOnly:true
	    	},{
	    		xtype:'uniNumberfield',
	    		fieldLabel:'장부가액',
	    		name:'TOT_BOOKVALUE_AMT',
	    		readOnly:true
	    	},
		    	Unilite.popup('Employee',{
				fieldLabel: '법무담당', 
				valueFieldWidth: 90,
				textFieldWidth: 140,
				valueFieldName:'CONF_DRAFTER',
			    textFieldName:'CONF_DRAFTER_NAME',
			    readOnly: true
			})]
	    }],
		api: {
	 		load: 'arc100ukrService.selectForm2'		
		}
    });	 
	var subForm2 = Unilite.createSimpleForm('resultForm3',{
		region: 'north',
    	border:false,
//    	split:true,
	    items: [{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:150,
			tdAttrs: {align : 'center'},
			items :[{
				xtype:'component',
				html:'[관리일지]',
				componentCls : 'component-text_green',
				tdAttrs: {align : 'left'},
	    		width: 150
			}]
	    }]
    });	 
    
    var detailGrid = Unilite.createGrid('arc100ukrGrid', {
//    	split:true,
		layout: 'fit',
		region: 'center',
		excelTitle: '채권등록관리일지',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			onLoadSelectFirst: false,
			useRowNumberer: true,
			expandLastColumn: false,
			useRowContext: true,
    		state: {
				useState: true,			
				useStateList: true		
			}
        },
		features: [{
			id: 'detailGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'detailGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: directDetailStore,
		columns: [
			{ dataIndex: 'MNG_DATE'				,width:80},
			{ dataIndex: 'MNG_GUBUN'			,width:88},
			{ dataIndex: 'REMARK'				,width:250},
			{ dataIndex: 'RECEIVE_AMT'			,width:100},
			{ dataIndex: 'COLLECT_AMT'			,width:100},
			{ dataIndex: 'NOTE_NUM'				,width:120},
			{ dataIndex: 'EXP_DATE'				,width:88},
			{ dataIndex: 'DRAFTER'				,width:100}
		]
    });   

    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			id:'pageAll',
			items:[
				detailForm, subForm1, subForm2, detailGrid
			]	
		}],
		id  : 'arc100ukrApp',
		fnInitBinding: function(params){
			
			
			this.setDefault(params);
			UniAppManager.setToolbarButtons(['newData','query','save'], false);
            UniAppManager.setToolbarButtons(['reset'], true);
            
            detailForm.onLoadSelectText('RECE_DATE');
		},
		onQueryButtonDown: function() {      
		/*	if(!detailForm.getInvalidMessage()){
				
				return false;	//필수체크
			}else{*/
//				detailForm.mask('loading...');
//				subForm1.mask('loading...');
				var param= detailForm.getValues();
				
				detailForm.getForm().load({
					params: param,
					success: function(form, action) {
						
						SAVE_FLAG = action.result.data.SAVE_FLAG;
						
						
//						detailForm.unmask();
						
						
						subForm1.getForm().load({
							params: param,
							success: function(form, action) {
						
//								subForm1.unmask();
						
							},
							failure: function(form, action) {
//								subForm1.unmask();
							}
						})
						
						
						
						if(SAVE_FLAG == 'U'){
							UniAppManager.setToolbarButtons('delete',true);	
						}
						detailForm.getField('RECE_DATE').focus();  
					},
					failure: function(form, action) {
//						detailForm.unmask();
//						subForm1.unmask();
					}
				});
				directDetailStore.loadStoreRecords();	
				
				UniAppManager.setToolbarButtons('reset',true);
//				panelResult.setAllFieldsReadOnly(true);
				
//			}
		},
/*		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;	//필수체크
		
//			 var compCode = UserInfo.compCode;
        	 
        	 var r = {
			
//				COMP_CODE: compCode
	        };
			detailGrid.createRow(r);
		},*/
		onResetButtonDown: function() {
//			panelSearch.clearForm();
			detailForm.clearForm();
			subForm1.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			UniAppManager.app.fnInitInputFields();   
			UniAppManager.setToolbarButtons(['newData','query','save','delete'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
			
			SAVE_FLAG = '';
		},
		
		onSaveDataButtonDown: function(config) {	
			
			if(!detailForm.getInvalidMessage()) return; 
			Ext.getCmp('pageAll').getEl().mask('저장 중...','loading-indicator');
			var param = detailForm.getValues();
			param.SAVE_FLAG = SAVE_FLAG;
			detailForm.getForm().submit({
			params : param,
				success : function(form, action) {
	 				detailForm.getForm().wasDirty = false;
					detailForm.resetDirtyStatus();											
					UniAppManager.setToolbarButtons('save', false);	
	            	UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
	            	if(SAVE_FLAG == ''){
	            		detailForm.setValue('RECE_NO',action.result.RECE_NO);
	            	}
	            	Ext.getCmp('pageAll').getEl().unmask();  
	            	UniAppManager.app.onQueryButtonDown();
	            	
				},
				failure: function(){
					Ext.getCmp('pageAll').getEl().unmask();  
				}
			});
		},
		
		onDeleteDataButtonDown: function() {
			if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
				var param = detailForm.getValues();
				param.SAVE_FLAG = 'D';
				detailForm.getForm().submit({
					params : param,
					success : function(form, action) {
		 				detailForm.getForm().wasDirty = false;
						detailForm.resetDirtyStatus();											
//						UniAppManager.setToolbarButtons(['delete','save'],false);
		            	UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
		            	
		            	detailForm.clearForm();
						subForm1.clearForm();
						detailGrid.reset();
						directDetailStore.clearData();
						UniAppManager.app.fnInitInputFields();	
						
						UniAppManager.setToolbarButtons(['delete','save'],false);
					}	
				});
			}
		},
		/*onDeleteAllButtonDown: function() {			
			var records = directDetailStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){		
							detailGrid.reset();			
							UniAppManager.app.onSaveDataButtonDown();	
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		},*/
		setDefault: function(params){
			
			if(!Ext.isEmpty(params.RECE_NO)){
				this.processParams(params);
			}else{
				UniAppManager.app.fnInitInputFields();	
			}
		},
/*		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
	         var param= Ext.getCmp('resultForm').getValues();
	         
	         var prgId = '';
	         
	         
//	         if(라디오 값에따라){
//	         	prgId = 'arc100rkr';	
//	         }else if{
//	         	prgId = 'abh221rkr';
//	         }
	         
	         
	         var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/abh/arc100rkrPrint.do',
//	            prgID:prgId,
	            prgID: 'arc100rkr',
	               extParam: {
	                    COMP_CODE:       	param.COMP_CODE       
//						INOUT_SEQ:  	    param.INOUT_SEQ,  	 
//						INOUT_NUM:          param.INOUT_NUM,      
//						DIV_CODE:           param.DIV_CODE, 
//						INOUT_CODE:         param.INOUT_CODE,      
//						INOUT_DATE:         param.INOUT_DATE,      
//						ITEM_CODE:          param.ITEM_CODE,       
//						INOUT_Q:            param.INOUT_Q,         
//						INOUT_P:            param.INOUT_P,         
//						INOUT_I:            param.INOUT_I,
//						INOUT_DATE_FR:      param.INOUT_DATE_FR,      
//						INOUT_DATE_TO:      param.INOUT_DATE_TO  
	               }
	            });
	            win.center();
	            win.show();
	               
	      }*/
		processParams: function(params) {
			this.uniOpt.appParams = params;
			
			if(params.PGM_ID == 'arc100skr') {
				detailForm.setValue('RECE_NO',params.RECE_NO);
				this.onQueryButtonDown();
			}else if(params.PGM_ID == 'arc110ukr') {
                detailForm.setValue('RECE_NO',params.RECE_NO);
                this.onQueryButtonDown();
			}
		},
		
		fnInitInputFields: function(){
			
			
			
			detailForm.setValue('RECE_DATE',UniDate.get('today'));
			
			detailForm.setValue('DRAFTER',UserInfo.personNumb);
			detailForm.setValue('DRAFTER_NAME',personName);
			
			detailForm.setValue('GW_STATUS','0');
		}
	});
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			
			}
				return rv;
						}
			});	
/*	Unilite.createValidator('validator02', {
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case fieldName:
//				    if(newValue != lastValidValue){
//					   UniAppManager.setToolbarButtons('save',true);
//				    }
					break;
			}
			return rv;
		}
	});		*/
};
window.addEventListener("beforeunload", arc100unload);
function arc100unload(event) {
    if(gsWin != null){
        gsWin.close();
    }
}
</script>

<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="WF_BOND_TR_REQ" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>