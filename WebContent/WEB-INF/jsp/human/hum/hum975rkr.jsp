<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum975rkr"  >
		<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var certi_Num = ''; // 증명번호 마지막 번호
var aRefConfig0 = '';  // 대표자명
var aRefConfig1 = '';  // 직위표시방법
var aRefConfig2 = '';  // 로그인 사용자 사번

var csHeaderRowsCnt = 0 // 상수값 설정

function appMain() {
	
	
	Unilite.defineModel('hum975rkrSubModel', {
    	fields: [ {name: 'COMP_CODE'	 			,text: '법인코드' 				,type: 'string', allowBlank: false},
		    	  {name: 'PERSON_NUMB'	 			,text: '사번' 				,type: 'string', allowBlank: false},
				  {name: 'PROF_NUM'	 				,text: '증명번호' 				,type: 'string', allowBlank: false},
		    	  {name: 'PROF_SEQ'	 				,text: '순번' 				,type: 'string', allowBlank: false},
		    	  {name: 'CARR_STRT_DATE'	 		,text: '근무시작일' 			,type: 'uniDate', allowBlank: false , maxLength:10},
		    	  {name: 'CARR_END_DATE'	 		,text: '근무종료일' 			,type: 'uniDate', allowBlank: false , maxLength:10},
		    	  {name: 'POST_NAME'	 			,text: '직급' 				,type: 'string' , maxLength:20},
		    	  {name: 'DEPT_NAME'	 			,text: '근무부서' 				,type: 'string' , maxLength:20},
		    	  {name: 'JOB_NAME'	 				,text: '담당업무' 				,type: 'string' , maxLength:20},
		    	  {name: 'INSERT_DB_USER'	 		,text: '작성자' 				,type: 'string'},
		    	  {name: 'INSERT_DB_TIME'	 		,text: '작성시간' 				,type: 'uniDate'},
		    	  {name: 'UPDATE_DB_USER'	 		,text: '수정자' 				,type: 'string'},
		    	  {name: 'UPDATE_DB_TIME'	 		,text: '수정시간' 				,type: 'uniDate'}	 
		]
	});
	
	var directSubProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'hum975rkrService.selectList',
			update: 'hum975rkrService.updateDetail',
			create: 'hum975rkrService.insertDetail',
			destroy: 'hum975rkrService.deleteDetail',
			syncAll: 'hum975rkrService.saveAll'
		}
	});
	
	var directSubStore = Unilite.createStore('hum975rkrSubStore', {
		model: 'hum975rkrSubModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,		// 상위 버튼 연결
        	editable: true,			// 수정 모드 사용
        	deletable:true,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: directSubProxy
        ,loadStoreRecords : function()	{
			var param = panelResult2.getValues();			
			console.log( param );
			this.load({ params : param});
		},
		saveStore : function(config)	{
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
        	
			if(inValidRecs.length == 0 )	{										
				config = {
						success: function(batch, option) {								
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);								
							//directMasterStore.loadStoreRecords();	
						 } 
				};					
				this.syncAllDirect(config);
				
			}else {
				subGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var subGrid = Unilite.createGrid('hum975rkrsubGrid', {    	
    	store : directSubStore,
    	sortableColumns : false,
    	height: 244,
    	width: 620,
    	//margin: '0 0 0 95',
    	excelTitle: '경력',
    	//border:false,
    	uniOpt:{
			expandLastColumn: false,
		 	copiedRow: true
    	},
        columns:  [ // { dataIndex: 'COMP_CODE'	 			,  		width: 100 , hidden: true}
			  		//,{ dataIndex: 'PERSON_NUMB'	 			,  		width: 100 , hidden: true}
			  		//,{ dataIndex: 'PROF_NUM'		 		,  		width: 100 , hidden: true}
			  		//,{ dataIndex: 'PROF_SEQ'				,  		width: 100 , hidden: true}
			  		{ dataIndex: 'CARR_STRT_DATE'			,  		width: 100 }
			  		,{ dataIndex: 'CARR_END_DATE'			,  		width: 100 }
			  		,{ dataIndex: 'POST_NAME'				,  		width: 88  }
			  		,{ dataIndex: 'DEPT_NAME'				,  		width: 155 }
			  		,{ dataIndex: 'JOB_NAME'				,  		width: 140 }
			  		//,{ dataIndex: 'INSERT_DB_USER'			,  		width: 100 , hidden: true}  		
			  		//,{ dataIndex: 'INSERT_DB_TIME'	 		,  		width: 100 , hidden: true}
			  		//,{ dataIndex: 'UPDATE_DB_USER'	 		,  		width: 100 , hidden: true}
			  		//,{ dataIndex: 'UPDATE_DB_TIME'	 		,  		width: 100 , hidden: true}
          ] ,
          listeners: {          	
			beforeedit  : function( editor, e, eOpts ) {
        		/*if(UniUtils.indexOf(e.field, ['CARR_STRT_DATE', 'CARR_END_DATE', 'POST_NAME', 'DEPT_NAME', 'JOB_NAME'])) {
					return true;
				}else{
					return false;
				}*/
			}
         }
    });
	
	

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
				xtype: 'radiogroup',		            		
				fieldLabel: '출력선택',						            		
				id: 'optPrintGb',
				labelWidth: 90,
				items: [{
					boxLabel: '재직증명서', 
					width: 120, 
					name: 'optPrintGb',
					inputValue: '1',
					checked: true  
				},{
					boxLabel: '경력증명서', 
					width: 120, 
					name: 'optPrintGb',
					inputValue: '0'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
						if(Ext.getCmp('optPrintGb').getChecked()[0].inputValue == '1') {
							UniAppManager.setToolbarButtons(['print'], true);
							UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
							//subGrid.hide();
							Ext.getCmp('career').setHidden(true);
						} else {
							UniAppManager.setToolbarButtons(['print', 'reset', 'newData', 'delete'], true);
							UniAppManager.setToolbarButtons(['query', 'save', 'detail'], false);	
							//subGrid.show();
							Ext.getCmp('career').setHidden(false);
							
							//if()
							//UniAppManager.app.onQueryButtonDown();
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
	                    	
	                    	UniAppManager.app.fnDeleteAllData();	// Hum975T 전체 삭제
	                    	subGrid.getStore().removeAll();			// 그리드 초기화
	                    	
	                    	UniAppManager.app.fnHumanCheck(records);
	                    	
						},
						scope: this
					},
					'onClear': function(type) {
						panelResult2.setValue('PERSON_NUMB','');
                    	panelResult2.setValue('NAME','');
					},
					applyextparam: function(popup){	
						//popup.setExtParam({'BASE_DT': '00000000'}); 
						//popup.setExtParam({'PAY_GUBUN': '1'}); 
					}
 				}
			}),{
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
			 	fieldLabel: '용도',
			 	xtype: 'uniTextfield',
			 	name: 'USE',
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
				xtype:'container',
				items:[{
					xtype: 'container',
					layout: {type: 'uniTable', columns: 2},	
					id:'career',
					items:[{
						xtype:'component',
						tdAttrs:{width: 95},
						html :'경&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;력',
						style: {
							marginTop: '3px !important',
							font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
						}
					},
					subGrid // SUB_GRID
					]
				}]
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
					  '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 이점 유의하시어 사전에 미리보기로 충분히 검토하신 후에 인쇄를 실행하여 </br>'+
					  '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 주시기 바랍니다. </br> ' ,
				style: {
					color: 'blue'				
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
		id: 'hum970rkrApp',
		fnInitBinding : function() {
			UniAppManager.app.fnDeleteAllData();
			
			Ext.getCmp('career').setHidden(true);
			
			UniAppManager.setToolbarButtons(['print'], true);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
			
			panelResult2.onLoadSelectText('NAME')
	
			var param = {"S_COMP_CODE": UserInfo.compCode};		
			hum975rkrService.fnHum975ini(param, function(provider, response){			// 증명번호 최신화
				if(!Ext.isEmpty(provider)){
					panelResult2.setValue('PROF_NUM' , provider.rsNUM);
					aRefConfig0 = provider.aRefConfig0;
					aRefConfig1 = provider.aRefConfig1;
					aRefConfig2 = provider.aRefConfig2;
				}
			});
		},
		/*onQueryButtonDown : function()	{

			subGrid.getStore().loadStoreRecords();
		},*/
		onNewDataButtonDown: function()	{
			var compCode   = UserInfo.compCode;  
			var personNumb = panelResult2.getValue('PERSON_NUMB');
			var profNum    = panelResult2.getValue('PROF_NUM');

			if(!csHeaderRowsCnt) csHeaderRowsCnt = 1;
    		else  csHeaderRowsCnt += 1;
			
    		if(csHeaderRowsCnt > 8){
    			return false;
    		}
			var r = {
				COMP_CODE   : compCode,
				PERSON_NUMB : personNumb,
				PROF_NUM    : profNum,
				PROF_SEQ    : csHeaderRowsCnt	
			}
			subGrid.createRow(r,'');
			
		},
		onDeleteDataButtonDown : function()	{
			subGrid.deleteSelectedRow();	
		},
		
		onSaveDataButtonDown: function() {
			directSubStore.saveStore();
		},
		onResetButtonDown:function() {
			
			var param = {"S_COMP_CODE": UserInfo.compCode};		
			hum975rkrService.fnHum975ini(param, function(provider, response){			// 증명번호 최신화
				if(!Ext.isEmpty(provider)){
					
					UniAppManager.setToolbarButtons(['print'], true);
					UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
					
					panelResult2.setValue('NAME' 		, '');
					panelResult2.setValue('PERSON_NUMB' , '');
					panelResult2.setValue('PROF_NUM' 	, provider.rsNUM);
					//panelResult2.setValue('ISS_DATE' , provider.rsNUM);  // FormatDate(txtIssDate.Value,goCnn.getUI("FDAY"))
					panelResult2.setValue('USE' 		, '');

					panelResult2.getField('rdoEncrypt').setValue('Y');
					
					panelResult2.clearForm();
					subGrid.getStore().loadData({});
					
					UniAppManager.setToolbarButtons(['print', 'reset', 'newData', 'delete'], true);
					UniAppManager.setToolbarButtons(['query', 'save', 'detail'], false);	
				}
			});
			
		},
		fnDeleteAllData : function()	{
			
			var param = {"S_COMP_CODE": UserInfo.compCode};	
			hum975rkrService.fnDeleteAllData(param, function(provider, response){		
			});
		},
        onPrintButtonDown: function() {
        	if(!panelResult2.getInvalidMessage()) return;   
        	
        	var doc_Kind = Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
        	
			var title_Doc = '';
			var text_Doc  = '';
			var prgID1    = '';
			
			if(doc_Kind == '1' ){
				title_Doc = '재직증명서'; 
				text_Doc  = Msg.sMH1223; // 재직중임을 증명하여 주시기 바랍니다.
				//prgID1    = 'hum975rkr1';
				prgID1    = 'hum975rkr';
			}
			else if(doc_Kind == '0'){
				title_Doc = '경력증명서'; 
				text_Doc  = '';
				//prgID1    = 'hum975rkr2';
				prgID1    = 'hum975rkr';
			}

			if(doc_Kind == '0'){
        		UniAppManager.app.onSaveDataButtonDown();
        	}
			
			var param  = Ext.getCmp('resultForm').getValues();			// 상단 증명서 종류
			var param2 = Ext.getCmp('resultForm2').getValues();			// 하단 검색조건
			
	        var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/hum/hum975rkrPrint.do',
	            prgID: prgID1,
	               extParam: {
	               	  DOC_KIND		: Ext.getCmp('optPrintGb').getChecked()[0].inputValue,		  // bParam(0) // 증명서 종류 
	               						// 재직증명서 : 1 , 증명서 : 2
	                  PERSON_NUMB  	: param2.PERSON_NUMB,  										
	                  ISS_DATE 		: param2.ISS_DATE,	   										
	                  PROF_NUM		: param2.PROF_NUM,	   	
	                  //bParam(5) = mid(goCnn.GetUi("FDAY"),5,1)    
	                  COMP_CODE     : UserInfo.compCode,	  									
	                  ENCRYPT		: Ext.getCmp('rdoEncrypt').getChecked()[0].inputValue, 		
	                  
	                  // 레포트로 파라미터 넘기기 매개변수 (조회와 관련 없음)
	                  
	                  REPER_NAME	: aRefConfig0,
	                  LOGIN_PERSON  : aRefConfig2,		// 로그인 사번
	                  USE           : param2.USE,		// 용도
	                  
	                  LOGIN_DEPT_NAME : UserInfo.deptName,		// 로그인한 유저의 부서
	                  LOGIN_NAME	: UserInfo.userName			// 로그인한 유저의 사용자명
	               }
	            });
	            win.center();
	            win.show();
	            
	            if(win.show){		// fnUpdateChanges() 넣는 곳
	            	
	            	UniAppManager.app.fnUpdateChanges(); // 증명번호 + 1
	            }
	    },
	    fnUpdateChanges : function() {
	    	// fnUpdateChanges()
	    	var param  = Ext.getCmp('resultForm2').getValues();			// 상단 증명서 종류 
	    	
	    	var bParam0 = Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
	    	var bParam4 = '1' // 한글
	    	
	    	if(bParam0 == '1'){
	    		bParam0 = '1';
	    	}else{
	    		bParam0 = '0';
	    	}
	    	
	    	param.optPrintGb = bParam0;
	    	param.bParam4    = bParam4;

	    	hum975rkrService.insertProfNum(param, function(provider, response){	
	    		hum975rkrService.fnHum975ini(param, function(provider2, response){
					if(!Ext.isEmpty(provider2)){
						panelResult2.setValue('PROF_NUM', provider2.rsNUM);
						//subGrid.getSelectedRecord().set('PROF_NUM' , provider2.rsNUM )
					}	
	    		});
			});
	    },
	    fnHumanCheck: function(records) {
	    	this.onNewDataButtonDown();
	    	
			grdRecord = subGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
			grdRecord.set('NAME', record.NAME);
			
			grdRecord.set('CARR_STRT_DATE', record.JOIN_DATE);
			
			if(record.RETR_DATE == '' || record.RETR_DATE == '00000000'){
				grdRecord.set('CARR_END_DATE', panelResult2.getValue('ISS_DATE'));
			}else{
				grdRecord.set('CARR_END_DATE', panelResult2.getValue('RETE_DATE'));
			}	
			grdRecord.set('DEPT_NAME', record.DEPT_NAME);
			grdRecord.set('POST_NAME', record.POST_CODE_NAME);
			grdRecord.set('JOB_NAME', record.JOB_NAME);
		}
	}); //End of 	Unilite.Main( {
	
	
	
	Unilite.createValidator('validator01', {
		store: directSubStore,
		grid: subGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			var selectRecord = subGrid.getSelectedRecord();
			var startDate = UniDate.getDbDateStr(selectRecord.get('CARR_STRT_DATE'));
			var endDate =  UniDate.getDbDateStr(selectRecord.get('CARR_END_DATE'));
			
			switch(fieldName) {
				case "CARR_STRT_DATE" : // 근무 시작일
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					
					/*if(endDate != '' || endDate != null){
						if(UniDate.getDbDateStr(newValue) > endDate){
							rv="근무 시작일 보다 근무 종료일이 클 수 없습니다.";
							break;
						}
						break;
					}*/
					break;
				
				case "CARR_END_DATE" : // 근무 종료일
					if( 18891231 > UniDate.getDbDateStr(newValue) ){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					if ( UniDate.getDbDateStr(newValue) > 30000101){
						rv="연도는 (1900 ~ 2999) 년 범위내의 값만 입력 할 수 있습니다.";
						break;
					}
					/*if(endDate != '' || endDate != null){
						if(UniDate.getDbDateStr(newValue) < startDate){
							rv="근무 시작일 보다 근무 종료일이 클 수 없습니다.";
							break;
						}
						break;
					}*/
					break;
				
			}
			return rv;
		}
	}); // validator
};

</script>
