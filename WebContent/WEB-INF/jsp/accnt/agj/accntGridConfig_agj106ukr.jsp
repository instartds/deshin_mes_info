<%@page language="java" contentType="text/html; charset=utf-8"%>
	var tempEditMode = true;
		
	Unilite.defineModel('accntModel', { 
		// pkGen : user, system(default)
		fields: [ 
			 {name: 'AC_DAY'			,text:'일자'					,type : 'string',   allowBlank:false,maxLength:2} 
			,{name: 'SLIP_NUM'   		,text:'번호'					,type : 'int',	  allowBlank:false,maxLength:7} 
			,{name: 'SLIP_SEQ'			,text:'순번'					,type : 'int',	  editable:false} 
			,{name: 'DR_CR'				,text:'차대구분'				,type : 'string',   editable:true, defaultValue:'1', comboType:'AU', comboCode:'A001'}
			,{name: 'ACCNT'				,text:'계정코드'				,type : 'string',   editable:true, allowBlank:false,maxLength:16}
			,{name: 'ACCNT_NAME'		,text:'계정과목명'				,type : 'string',   editable:true, allowBlank:false,maxLength:50}
			,{name: 'CUSTOM_CODE'		,text:'거래처'				,type : 'string',   editable:true, maxLength:8} 
			,{name: 'CUSTOM_NAME'		,text:'거래처명'				,type : 'string',   editable:true, maxLength:40} 
			,{name: 'DR_AMT_I'			,text:'차변금액'				,type : 'uniPrice', editable:true} 
			,{name: 'CR_AMT_I'			,text:'대변금액'				,type : 'uniPrice', editable:true, maxLength:30} 
			,{name: 'REMARK'			,text:'적요'				,type : 'string',   editable:true, allowBlank:false,  maxLength:100 } 
			,{name: 'PROOF_KIND_NM'		,text:'증빙유형'				,type : 'string',   editable:true} 
			,{name: 'CREDIT_NUM_EXPOS'	,text:'카드번호/현금영수증'		,type : 'string',   editable:false , defaultValue:'***************'} 
			,{name: 'CREDIT_NUM_MASK'	,text:'카드번호/현금영수증'		,type : 'string',   editable:false , defaultValue:'***************'} 
			,{name: 'DEPT_NAME'			,text:'귀속부서'				,type : 'string',   editable:true, allowBlank:false, defaultValue:UserInfo.deptName,maxLength:30} 
			,{name: 'DIV_CODE'			,text:'사업장'				,type : 'string',   editable:true, allowBlank:false, comboType:'BOR120', defaultValue:UserInfo.divCode}
			,{name: 'SLIP_DIVI'			,text:'구분'					,type : 'string',   editable:true, allowBlank:false, defaultValue:'3', comboType:'A', comboCode:'A005'}
			
			,{name: 'OLD_AC_DATE'		,text:'OLD_AC_DATE'			,type : 'uniDate'} 
			,{name: 'OLD_SLIP_NUM'		,text:'OLD_SLIP_NUM'		,type : 'int'} 
			,{name: 'OLD_SLIP_SEQ'		,text:'OLD_SLIP_SEQ'		,type : 'int'}
			,{name: 'AC_DATE'			,text:'회계전표일자'			,type : 'uniDate'} 
			,{name: 'P_ACCNT'			,text:'상대계정코드'			,type : 'string'} 
			,{name: 'DEPT_CODE'			,text:'귀속부서코드'			,type : 'string', allowBlank:false, defaultValue:UserInfo.deptCode,maxLength:8} 
			,{name: 'PROOF_KIND'		,text:'증빙유형'				,type : 'string', maxLength:2, comboType:'AU', comboCode:'A022'} 
			,{name: 'CREDIT_CODE'		,text:'신용카드사코드'			,type : 'string'} 
			,{name: 'REASON_CODE'		,text:'불공제사유코드'			,type : 'string'} 
			,{name: 'CREDIT_NUM'		,text:'카드번호/현금영수증(DB)'	,type : 'string', editable:false} 
			,{name: 'MONEY_UNIT'		,text:'화폐단위'				,type : 'string', defaultValue:baseInfo.gsLocalMoney} 
			,{name: 'EXCHG_RATE_O'		,text:'환율'					,type : 'uniER'} 
			,{name: 'FOR_AMT_I'			,text:'외화금액'				,type : 'uniFC'}
			
			,{name: 'IN_DIV_CODE'		,text:'결의사업장코드'			,type : 'string', defaultValue:UserInfo.divCode} 
			,{name: 'IN_DEPT_CODE'		,text:'결의부서코드'			,type : 'string', defaultValue:UserInfo.deptCode} 
			,{name: 'IN_DEPT_NAME'		,text:'결의부서'				,type : 'string', defaultValue:UserInfo.deptName}
			,{name: 'BILL_DIV_CODE'		,text:'신고사업장코드'			,type : 'string', defaultValue:baseInfo.gsBillDivCode}
			
			,{name: 'AC_CODE1'			,text:'관리항목코드1'		,type : 'string'} 
			,{name: 'AC_CODE2'			,text:'관리항목코드2'		,type : 'string'} 
			,{name: 'AC_CODE3'			,text:'관리항목코드3'		,type : 'string'} 
			,{name: 'AC_CODE4'			,text:'관리항목코드4'		,type : 'string'} 
			,{name: 'AC_CODE5'			,text:'관리항목코드5'		,type : 'string'} 
			,{name: 'AC_CODE6'			,text:'관리항목코드6'		,type : 'string'}
			
			,{name: 'AC_NAME1'			,text:'관리항목명1'		,type : 'string'} 
			,{name: 'AC_NAME2'			,text:'관리항목명2'		,type : 'string'} 
			,{name: 'AC_NAME3'			,text:'관리항목명3'		,type : 'string'} 
			,{name: 'AC_NAME4'			,text:'관리항목명4'		,type : 'string'} 
			,{name: 'AC_NAME5'			,text:'관리항목명5'		,type : 'string'} 
			,{name: 'AC_NAME6'			,text:'관리항목명6'		,type : 'string'}
			
			,{name: 'AC_DATA1'			,text:'관리항목데이터1'		,type : 'string'} 
			,{name: 'AC_DATA2'			,text:'관리항목데이터2'		,type : 'string'} 
			,{name: 'AC_DATA3'			,text:'관리항목데이터3'		,type : 'string'} 
			,{name: 'AC_DATA4'			,text:'관리항목데이터4'		,type : 'string'} 
			,{name: 'AC_DATA5'			,text:'관리항목데이터5'		,type : 'string'} 
			,{name: 'AC_DATA6'			,text:'관리항목데이터6'		,type : 'string'}
			
			,{name: 'AC_DATA_NAME1'		,text:'관리항목데이터명1'	,type : 'string'} 
			,{name: 'AC_DATA_NAME2'		,text:'관리항목데이터명2'	,type : 'string'} 
			,{name: 'AC_DATA_NAME3'		,text:'관리항목데이터명3'	,type : 'string'} 
			,{name: 'AC_DATA_NAME4'		,text:'관리항목데이터명4'	,type : 'string'} 
			,{name: 'AC_DATA_NAME5'		,text:'관리항목데이터명5'	,type : 'string'} 
			,{name: 'AC_DATA_NAME6'		,text:'관리항목데이터명6'	,type : 'string'}
			
			,{name: 'BOOK_CODE1'		,text:'계정잔액코드1'		,type : 'string'} 
			,{name: 'BOOK_CODE2'		,text:'계정잔액코드2'		,type : 'string'} 
			,{name: 'BOOK_DATA1'		,text:'계정잔액데이터1'		,type : 'string'} 
			,{name: 'BOOK_DATA2'		,text:'계정잔액데이터2'		,type : 'string'} 
			,{name: 'BOOK_DATA_NAME1'	,text:'계정잔액데이터명1'	,type : 'string'} 
			,{name: 'BOOK_DATA_NAME2'   ,text:'계정잔액데이터명2'	,type : 'string'} 
			
			,{name: 'ACCNT_SPEC'   		,text:'계정특성'			,type : 'string'} 
			,{name: 'SPEC_DIVI'			,text:'자산부채특성'		,type : 'string', comboType:'AU', comboCode:'A016'} 
			,{name: 'PROFIT_DIVI'		,text:'손익특성'			,type : 'string'} 
			,{name: 'JAN_DIVI'			,text:'잔액변(차대)'		,type : 'string'} 
			,{name: 'PEND_YN'			,text:'미결관리여부'		,type : 'string'} 
			,{name: 'PEND_CODE'			,text:'미결항목'			,type : 'string'} 
			,{name: 'PEND_DATA_CODE'  	,text:'미결항목데이터코드'	,type : 'string'} 
			,{name: 'BUDG_YN'			,text:'예산사용여부'		,type : 'string'} 
			,{name: 'BUDGCTL_YN'		,text:'예산통제여부'		,type : 'string'} 
			,{name: 'FOR_YN'			,text:'외화구분'			,type : 'string'} 
			
			,{name: 'POSTIT_YN'			,text:'주석체크여부'		,type : 'string'} 
			,{name: 'POSTIT'			,text:'주석내용'			,type : 'string'} 
			,{name: 'POSTIT_USER_ID'  	,text:'주석체크자'			,type : 'string'} 
			
			,{name: 'INPUT_PATH'		,text:'입력경로'			,type : 'string', defaultValue: csINPUT_PATH} 
			,{name: 'INPUT_DIVI'		,text:'전표입력경로'		,type : 'string', defaultValue: csINPUT_DIVI} 
			,{name: 'AUTO_SLIP_NUM'   	,text:'자동기표번호'		,type : 'string'} 
			,{name: 'CLOSE_FG'			,text:'마감여부'			,type : 'string'} 
			,{name: 'INPUT_DATE'		,text:'입력일자'			,type : 'string'} 
			,{name: 'INPUT_USER_ID'   	,text:'입력자ID'			,type : 'string'} 
			,{name: 'CHARGE_CODE'		,text:'담당자코드'			,type : 'string'} 
			,{name: 'CHARGE_NAME'		,text:'담당자명'			,type : 'string'} 
			
			,{name: 'AP_STS'			,text:'승인상태'			,type : 'string', defaultValue:'1'} 
			,{name: 'AP_DATE'			,text:'승인처리일'			,type : 'string'} 
			,{name: 'AP_USER_ID'		,text:'승인자ID'			,type : 'string'} 
			,{name: 'EX_DATE'			,text:'회계전표일자'		,type : 'string'} 
			,{name: 'EX_NUM'			,text:'회계전표번호'		,type : 'int'} 
			,{name: 'EX_SEQ'			,text:'회계전표순번'		,type : 'string'} 
			
			,{name: 'AC_CTL1'   		,text:'관리항목필수1'		,type : 'string'} 
			,{name: 'AC_CTL2'   		,text:'관리항목필수2'		,type : 'string'} 
			,{name: 'AC_CTL3'   		,text:'관리항목필수3'		,type : 'string'} 
			,{name: 'AC_CTL4'   		,text:'관리항목필수4'		,type : 'string'} 
			,{name: 'AC_CTL5'			,text:'관리항목필수5'		,type : 'string'} 
			,{name: 'AC_CTL6'			,text:'관리항목필수6'		,type : 'string'} 
			
			,{name: 'AC_TYPE1'   		,text:'관리항목1유형'		,type : 'string'} 
			,{name: 'AC_TYPE2'   		,text:'관리항목2유형'		,type : 'string'} 
			,{name: 'AC_TYPE3'   		,text:'관리항목3유형'		,type : 'string'} 
			,{name: 'AC_TYPE4'   		,text:'관리항목4유형'		,type : 'string'} 
			,{name: 'AC_TYPE5'   		,text:'관리항목5유형'		,type : 'string'} 
			,{name: 'AC_TYPE6'   		,text:'관리항목6유형'		,type : 'string'} 
			
			,{name: 'AC_LEN1'			,text:'관리항목1길이'		,type : 'string'} 
			,{name: 'AC_LEN2'   		,text:'관리항목2길이'		,type : 'string'} 
			,{name: 'AC_LEN3'   		,text:'관리항목3길이'		,type : 'string'} 
			,{name: 'AC_LEN4'   		,text:'관리항목4길이'		,type : 'string'} 
			,{name: 'AC_LEN5'   		,text:'관리항목5길이'		,type : 'string'} 
			,{name: 'AC_LEN6'   		,text:'관리항목6길이'		,type : 'string'} 
			
			,{name: 'AC_POPUP1'		,text:'관리항목1팝업여부'	,type : 'string'} 
			,{name: 'AC_POPUP2'   		,text:'관리항목2팝업여부'	,type : 'string'} 
			,{name: 'AC_POPUP3'   		,text:'관리항목3팝업여부'	,type : 'string'} 
			,{name: 'AC_POPUP4'   		,text:'관리항목4팝업여부'	,type : 'string'} 
			,{name: 'AC_POPUP5'   		,text:'관리항목5팝업여부'	,type : 'string'} 
			,{name: 'AC_POPUP6'   		,text:'관리항목6팝업여부'	,type : 'string'} 
			
			,{name: 'AC_FORMAT1'  		,text:'관리항목1포멧'		,type : 'string'} 
			,{name: 'AC_FORMAT2'   		,text:'관리항목2포멧'		,type : 'string'} 
			,{name: 'AC_FORMAT3'   		,text:'관리항목3포멧'		,type : 'string'} 
			,{name: 'AC_FORMAT4'   		,text:'관리항목4포멧'		,type : 'string'} 
			,{name: 'AC_FORMAT5'   		,text:'관리항목5포멧'		,type : 'string'} 
			,{name: 'AC_FORMAT6'   		,text:'관리항목6포멧'		,type : 'string'} 
			,{name: 'COMP_CODE'			,text:'법인코드'			,type : 'string'} 
			,{name: 'AMT_I'				,text:'금액'				,type : 'uniPrice'} 
			,{name: 'DRAFT_CODE'   		,text:'기안상태(E-Ware)'	,type : 'string'} 
			,{name: 'DRAFT_YN'   		,text:'기안 여부(E-Ware)'	,type : 'string'} 
			,{name: 'AGREE_YN'			,text:'결재완료(E-Ware)'	,type : 'string'} 
			,{name: 'CASH_NUM'			,text:'CASH_NUM'		,type : 'string'}
			,{name: 'OPR_FLAG'			,text:'editFlag'		,type : 'string', defaultValue:'L'} 
			,{name: 'AP_CHARGE_CODE'	,text:''				,type : 'string', defaultValue:''} 
			
			/*계정코드 복사용 필수입력*/
			,{name: 'CR_CTL1'   		,text:'관리항목필수1'		,type : 'string'} 
			,{name: 'CR_CTL2'   		,text:'관리항목필수2'		,type : 'string'} 
			,{name: 'CR_CTL3'   		,text:'관리항목필수3'		,type : 'string'} 
			,{name: 'CR_CTL4'   		,text:'관리항목필수4'		,type : 'string'} 
			,{name: 'CR_CTL5'   		,text:'관리항목필수5'		,type : 'string'} 
			,{name: 'CR_CTL6'   		,text:'관리항목필수6'		,type : 'string'} 
			
			,{name: 'DR_CTL1'   		,text:'관리항목필수1'		,type : 'string'} 
			,{name: 'DR_CTL2'   		,text:'관리항목필수2'		,type : 'string'} 
			,{name: 'DR_CTL3'   		,text:'관리항목필수3'		,type : 'string'} 
			,{name: 'DR_CTL4'   		,text:'관리항목필수4'		,type : 'string'} 
			,{name: 'DR_CTL5'   		,text:'관리항목필수5'		,type : 'string'} 
			,{name: 'DR_CTL6'   		,text:'관리항목필수6'		,type : 'string'}
			
			
			,{name: 'REPORT_TYPE'   	,text:'전표양식'		,type : 'string'} 
			,{name: 'REMARK2'   		,text:'전표제목'		,type : 'string'} 
			,{name: 'DRAFT_NO'   		,text:'기안번호'		,type : 'string'} 
			,{name: 'GW_DOC'   			,text:'GW_DOC'		,type : 'string'}
			,{name: 'OLD_ACCNT'   		,text:'이전계정코드'	,type : 'string'}
			/*계정코드 복사용 필수입력*/
			 
		]
	});
	function getStoreConfig() {
		var config = {
			
			model: 'accntModel',
			autoLoad: false,
			uniOpt : {
				isMaster: true,			// 상위 버튼 연결
				editable: true,			// 수정 모드 사용
				deletable:true,			// 삭제 가능 여부
				useNavi : false			// prev | next 버튼 사용
			},
			proxy: directProxy // proxy
			// Store 관련 BL 로직
			// 검색 조건을 통해 DB에서 데이타 읽어 오기
			,loadStoreRecords : function(gParam, cbFunction) {
				var param ;
				if(gParam ) {
					param = gParam
				}else {
					var form = Ext.getCmp('searchForm');
					if(form.isValid()) {
						if(form.getField("AC_DATE_FR")) {
							if(UniDate.extFormatMonth(form.getValue("AC_DATE_FR")) != UniDate.extFormatMonth(form.getValue("AC_DATE_TO")) ) {
								 panelSearch.setValue("AC_DATE_TO",'');
								 panelResult.setValue("AC_DATE_TO",'');
								alert('동일한 월만 조회가 가능합니다.')	;
								return;
							}
						}
						if(csINPUT_DIVI == "2") {  // 회계,결의전표(번호별)
							if(csSLIP_TYPE=="1"){		//회계
								param= {
									'AC_DATE':UniDate.getDateStr(form.getValue("AC_DATE")),
									'SLIP_NUM':form.getValue("SLIP_NUM"),
									'AUTHORITY':form.getValue("AUTHORITY"),
									'IN_DEPT_CODE':form.getValue("IN_DEPT_CODE"),
									'CHARGE_CODE':form.getValue("CHARGE_CODE")
									
									
								};
							}else {		//결의
								param= {
									'AC_DATE':UniDate.getDateStr(form.getValue("AC_DATE")),
									'EX_NUM':form.getValue("EX_NUM"),
									'AUTHORITY':form.getValue("AUTHORITY"),
									'IN_DEPT_CODE':form.getValue("IN_DEPT_CODE"),
									'CHARGE_CODE':form.getValue("CHARGE_CODE")
								};
							}
						}else {
							param= form.getValues();
						}
						if(gsProcessPgmId){
							param.SLIP_NUM	= gsSlipNum;		//SLIP_NUM 전역 변수 사용하여 Link로 넘어왔을 때 조회 되게 처리함.
						}
					//20200702 추가
					} else {
						if(!panelSearch.getInvalidMessage()) return false;
					}
				}
				param.PGM_ID = 'agj106ukr';
				if(param) {
					UniAppManager.app.setSearchReadOnly(true);
					this.load({
						params : param,
						callback:cbFunction
					});
				}
				
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기
			,saveStore : function(config) {	
				var activeTab
				var activeTabId;
				if(tab) {
					activeTab = tab.getActiveTab();
					activeTabId = activeTab.getItemId();
				}else {
					activeTabId = 'agjTab1'
				}
				var paramMaster = {};
				
				
				var insertRecords=this.getNewRecords( );
				var updateRecords=this.getUpdatedRecords( );
				var removedRecords=this.getRemovedRecords( );
				// editFlag
				//N: 변동없음, I: 신규, U: 수정 R:삭제
				Ext.each(insertRecords, function(record){
					record.set('OPR_FLAG', 'N');
					if(Ext.isEmpty(record.get('DRAFT_CODE'))) {
						record.set('DRAFT_CODE', '0');
					}
				});
				Ext.each(updateRecords, function(record){record.set('OPR_FLAG', 'U');});
				Ext.each(removedRecords, function(record){record.set('OPR_FLAG', 'D');});
				
				var changedRec = [].concat(insertRecords).concat(updateRecords).concat(removedRecords);
				
				
				Ext.each(changedRec, function(cRec){
					if(Ext.isEmpty(cRec.get('CHARGE_CODE'))) {
						cRec.set('CHARGE_CODE',panelSearch.getValue('CHARGE_CODE'));
					}
					  
				})
				/**
				 * 변경된 record와 같은 전표번호 데이타를 서버로 전송하기 위해 OPR_FLAG값 변경
				 */
				Ext.each(this.data.items, function(record){
					if(record.get('OPR_FLAG') == 'L') {
						Ext.each(changedRec, function(cRec){
							if(UniDate.getDateStr(record.get('AC_DATE')) == UniDate.getDateStr(cRec.get('AC_DATE')) &&
							   record.get('SLIP_NUM') == cRec.get('SLIP_NUM')	
							  ) {
								record.set('OPR_FLAG','')
							  }
							  
						})
						
					}
				});
				
				updateRecords=this.getUpdatedRecords( );
				//changedRec = [].concat(insertRecords).concat(updateRecords).concat(removedRecords);
				/**
				 * 관리항목 필수 사항 체크, 순번 저장
				 */
				
				var saveRec = [].concat(insertRecords).concat(updateRecords);
				var slipNum = 0;
				var slipSeq=1
				var chk = true;
				
				Ext.each(this.data.items, function(rec){	
					var loopSlipNum = rec.get('SLIP_NUM');
					  
					  //매입매출의 경우 cash_num 값도 수정, 순번이 변경되기 전에 반대 계정 찾기
					  /*var cashItemId = this.findBy(function(cashRec, idx){
						return rec.get('AC_DAY') == cashRec.get('AC_DAY') && rec.get('SLIP_NUM')==cashRec.get('SLIP_NUM') && rec.get('CASH_NUM') == cashRec.get('SLIP_SEQ');
					  });
					  var cashItem ;
					  if(cashItemId > 0) {
						cashItem = this.getAt(cashItemId)
					  }*/
					  
					  if(slipNum == 0 ) {
						rec.set('SLIP_SEQ', slipSeq);
					  }	else if(loopSlipNum == slipNum) {
						rec.set('SLIP_SEQ', ++slipSeq);
					  }else {
						slipSeq = 1;
						rec.set('SLIP_SEQ', slipSeq);
					  }
					  slipNum = rec.get('SLIP_NUM');
				});	  
				
				Ext.each(saveRec, function(rec){	
					  //순번 저장
					  
					  
					  //cash_num 값도 수정
					  /*if(cashItemId > 0) {
						cashItem.set("CASH_NUM", item.get('SLIP_SEQ'));
					  }*/
					  
					  //관리항목 필수 사항 체크
					  
					  for(var i=1; i <= 6; i++) {
						if(!UniUtils.indexOf(panelSearch.getValue(), ['50','52','58'])) {
							if(rec.get("AC_CTL"+i.toString()) =="Y" ) {
								if(Ext.isEmpty(rec.get("AC_DATA"+i.toString()))) {
									alert("전표번호 " + rec.get("SLIP_NUM")+",전표순번 "+rec.get("SLIP_SEQ")+"의 "+rec.get("AC_NAME"+i.toString())+"을(를) 입력해 주세요.");
									chk=false;
									break;
								}
							}
						}
						if(rec.get("AC_FORMAT"+i.toString())=="D" ) {
							if(rec.get("AC_DATA"+i.toString()) && rec.get("AC_DATA"+i.toString()).length != 8) {
								rec.set("AC_DATA"+i.toString(), UniDate.getDateStr(new Date(rec.get("AC_DATA"+i.toString()))));
							}
						}
					  }
					  
					  
				})
				
				if(!chk) {
					return;
				}
				
				//차대변 금액이 일치하는지 검사
				var checkDCSum = this.checkSum();
				if(checkDCSum !== true) {
					alert(Msg.sMA0052+'\n'+'전표번호:'+checkDCSum);
					return;
				}
				//같은 전표안에서 대체차변, 대체대변과 입금, 출금이 동시에 존재하는지를 체크
				if(!this.checkDivi()) {
					return;
				}
				
				Ext.each(insertRecords, function(rec){
					rec.set('OLD_AC_DATE', rec.get('AC_DATE'));
					rec.set('OLD_SLIP_NUM', rec.get('SLIP_NUM'));
					rec.set('OLD_SLIP_SEQ', rec.get('SLIP_SEQ'));
				});
				
				if(activeTabId == 'agjTab2' ) {
					paramMaster = salesGrid.getSelectedRecord().data;
					if(salesGrid.getSelectedRecord().phantom) {
						paramMaster.OPR_FLAG = 'N';
					}else {
						paramMaster.OPR_FLAG = 'U';
					}
					paramMaster.PUB_DATE = UniDate.getDbDateStr(paramMaster.PUB_DATE);
					paramMaster.OLD_PUB_DATE = UniDate.getDbDateStr(paramMaster.OLD_PUB_DATE);
					paramMaster.OLD_AC_DATE = UniDate.getDbDateStr(paramMaster.OLD_AC_DATE);
					paramMaster.AC_DATE = UniDate.getDbDateStr(paramMaster.AC_DATE);
					if(Ext.isEmpty(paramMaster.CHARGE_CODE) && !Ext.isEmpty(panelSearch.getValue('CHARGE_CODE'))) paramMaster.CHARGE_CODE = panelSearch.getValue('CHARGE_CODE');
				
					if(Ext.isEmpty(paramMaster.PUB_DATE)) {
						alert('계산서일을 입력해 주세요.');
						return;
					}
					
					if(!this.checkSupplySum(paramMaster.SUPPLY_AMT_I,paramMaster.TAX_AMT_I, paramMaster.PROOF_KIND)) {
						
						return;
					}
					
				}
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				
				if(inValidRecs.length == 0 ) {
					config = {
							params: [paramMaster],
							success: function(batch, option) {
			
//								var exNum = slipForm.getValue('EX_NUM');
//								if(!Ext.isEmpty(batch) &&
//									batch.hasOwnProperty('operations') &&
//									batch.operations.length > 0 &&
//									batch.operations[0].hasOwnProperty('_resultSet') )
//								{
//									var resultSet = batch.operations[0].getResultSet();
//									if(resultSet.hasOwnProperty('SLIP_NUM')) {
//										exNum = resultSet.SLIP_NUM;
//									}
//								}
//								
//								var param = {
//								 "AC_DATE" 		: UniDate.getDbDateStr(slipForm.getValue('AC_DATE')),
//								 "EX_NUM"  		: exNum,
//								 "REPORT_TYPE"  : slipForm.getValue('REPORT_TYPE'),
//								 "REMARK2"  	: slipForm.getValue('REMARK2')
//								}
//								
//								agj106ukrService.slipUpdate(param, function(provider, result ) {
//								});
								
								Ext.getCmp('GW').setDisabled(false);
								
								var draftCd = slipForm.getValue('DRAFT_CODE');

								if (draftCd == '' || draftCd == null){
									slipForm.setValue('DRAFT_CODE', '0');
								}
								
								var activeTab
								var activeTabId
								if(tab) {
									activeTab = tab.getActiveTab();
									activeTabId = activeTab.getItemId();
								}else {
									activeTabId = 'agjTab1';
								}
								
								if(activeTabId == 'agjTab2' ) {
									console.log("batch : " , batch);
									console.log("option : " , option);
									if(option && option.params) {
										var savedRecord = salesGrid.getSelectedRecord();
										savedRecord.set('PUB_NUM',option.params[0].PUB_NUM );
										savedRecord.set('SLIP_NUM',option.params[0].SLIP_NUM );
									}
									salesStore.commitChanges();
									salesStore.endUpdate( );
									salesGrid.getView().refresh();
								}else {
									if(csINPUT_DIVI == '2' &&  csSLIP_TYPE == '2') {
										slipForm.setValue('EX_NUM',batch.operations[0]._resultSet.SLIP_NUM)
									}else if(csINPUT_DIVI == '2' &&  csSLIP_TYPE == '1') {
										slipForm.setValue('SLIP_NUM',batch.operations[0]._resultSet.SLIP_NUM)
									}
								}
								if (directMasterStore1.count() == 0){
									UniAppManager.app.onResetButtonDown();
								}
							} 
					}
					
					var checkDuplicateRecords = Ext.Array.clone(this.getNewRecords());
					if(!Ext.isEmpty(checkDuplicateRecords)) {
						var checkDuplicateList = []
						Ext.each(checkDuplicateRecords, function(cRec, i){
							checkDuplicateList[i] = new Object();
							checkDuplicateList[i]['DR_CR'] 		 = cRec.get("DR_CR");
							checkDuplicateList[i]['AC_DATE'] 	 = UniDate.getDbDateStr(cRec.get("AC_DATE"));
							checkDuplicateList[i]['ACCNT'] 		 = cRec.get("ACCNT");
							checkDuplicateList[i]['ACCNT_NAME']  = cRec.get("ACCNT_NAME");
							checkDuplicateList[i]['CUSTOM_CODE'] = cRec.get("CUSTOM_CODE");
							checkDuplicateList[i]['CUSTOM_NAME'] = cRec.get("CUSTOM_NAME");
							checkDuplicateList[i]['AMT_I']		 = cRec.get("AMT_I");
							checkDuplicateList[i]['DIV_CODE']	 = cRec.get("DIV_CODE");
						});
						var checkDuplicateParam = {'csSLIP_TYPE' : csSLIP_TYPE, data:checkDuplicateList}
						var me = this;
						Ext.getBody().mask();
						agj100ukrService.selectDuplicate(checkDuplicateParam, function(provider, response){
							Ext.getBody().unmask();
							var vMessage = ""
							if(!Ext.isEmpty(provider)) {
								Ext.each(provider, function(item, idx) {
									vMessage += '전표일자 : '+UniDate.extFormatDate(UniDate.extParseDate(item.AC_DATE))+'\r\n'
												+ '계정코드 : '+item.ACCNT+'('+item.ACCNT_NAME+')'+'\r\n'
												+ '거 래  처 : '+item.CUSTOM_CODE+'('+item.CUSTOM_NAME+')'+'\r\n'
												+ '금	 액 : '+Ext.util.Format.number(item.AMT_I, '0,000')+'\r\n'
												+ '사 업 장 : '+item.DIV_CODE+'\r\n\r\n'	
								});
								var messageWin  =	Ext.create({
										xtype: 'window',
										height: 400,
										width: 500,
										alwaysOnTop : true,
										title: CommonMsg.errorTitle.ERROR,
										layout:'vbox',
										items:[{
											xtype:'container',
											layout:'hbox',
											flex:1,
											items:[{
												xtype:'image',
												width:31,
												height:31,
												margin:'20 10 10 30',
												src:CPATH+'/resources/images/main/icon-warning.gif'
											},{
												xtype : 'component',
												height: 100,
												width :385,
												html:"중복된 자료가 있습니다. 저장하시겠습니까?",
												scrollable:true,
												style:{
													'float':'left',
													'position':'absolute'
												},
												margin:'10 10 10 30'
											}]
										},{
											xtype:'container',
											width:470,
											layout:'hbox',
											margin:10,
											items:[{
												xtype:'component',
												flex:1,
												html:'&nbsp;'
											},{
												xtype:'button',
												text : UniUtils.getLabel('system.label.commonJS.window.btnSave','저장'),
												width:80,
												handler:function() {
													messageWin.destroy();
													setTimeout(function(){
														me.syncAllDirect(config);
													}, 10)
												}
											},{
												xtype:'component',
												html:'&nbsp;&nbsp;'
											},{
												xtype:'button',
												text : UniUtils.getLabel('system.label.commonJS.window.btnClose','취소'),
												width:80,
												handler:function() {
													messageWin.destroy();
													Ext.getBody().unmask();
												}
											}
											]
										},{
											xtype:'uniSearchForm',
											itemId:'messageComponent',
											items:[{
												xtype : 'textarea',
												name:'messageDetail',
												width: 490,
												height:250,
												hidden:false,
												fieldStyle :"background-color:#FFF",
												readOnly:true,
												value: vMessage
											}]
										}],
										listeners:{
											hide:function(){
												messageWin.destroy();
												Ext.getBody().unmask();
											},
											close:function(){
												Ext.getBody().unmask();
											}
										}
									}); 
									Ext.getBody().mask();
									messageWin.center();
									messageWin.show();
								
								} else {
									me.syncAllDirect(config);
								}
								
							});
						} else {
							this.syncAllDirect(config);
						}
				}else {
					alert(Msg.sMB083);
				}
			},
			checkSum:function() {
				var insertRecords=this.getNewRecords( );
				var updateRecords=this.getUpdatedRecords( );
				var removedRecords=this.getRemovedRecords( );
				
				
				var changedRec = [].concat(insertRecords).concat(updateRecords).concat(removedRecords);
				var rtn = true;
				var store = this;
				Ext.each(changedRec, function(rec) {
					var cr_data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== rec.get("AC_DAY") && record.get('SLIP_NUM')== rec.get("SLIP_NUM") && record.get('DR_CR') == '2') } ).items);		
					var dr_data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== rec.get("AC_DAY") && record.get('SLIP_NUM')== rec.get("SLIP_NUM") && record.get('DR_CR') == '1') } ).items);		
					
					var crSum=0;
					var crLen = cr_data.length;
					var drSum=0;
					var drLen = dr_data.length;
					if(rec.get('SLIP_DIVI') != 1 && rec.get('SLIP_DIVI') != 2) {
						Ext.each(cr_data, function(item){
							crSum += item.get("AMT_I");
							if(Ext.isEmpty(item.get('CASH_NUM'))) {
								if(drLen == 1) {
									item.set('P_ACCNT', dr_data[0].get('ACCNT'));
								}else {
									item.set('P_ACCNT', '99999');
								}
							}
						})
						Ext.each(dr_data, function(item){
							drSum += item.get("AMT_I");
							if(Ext.isEmpty(item.get('CASH_NUM'))) {
								if(crLen == 1) {
									item.set('P_ACCNT', cr_data[0].get('ACCNT'));
								}else {
									item.set('P_ACCNT', '99999');
								}
							}/*else {
								var pItemId = store.findBy(function(rec, idx){
									return rec.get('AC_DAY') == item.get('AC_DAY') && rec.get('SLIP_NUM')==item.get('SLIP_NUM') && rec.get('CASH_NUM') == item.get('SLIP_SEQ');
								});
								var pRecord = store.getAt(pItemId);
								item.set('P_ACCNT', pRecord.get('SLIP_SEQ'));
							}*/
						})
						crSum = crSum.toFixed(6);
						drSum = drSum.toFixed(6);
						console.log("crSum : ", crSum ," drSum =",drSum);
						if(crSum != drSum ) {
							
							rtn = rec.get('SLIP_NUM');						
						}
					
					}else {
						var cashAccnt  = "11110";
						if(cashInfo && cashInfo.ACCNT) {
							cashAccnt = cashInfo.ACCNT;
						}
						Ext.each(cr_data, function(item){
							item.set('P_ACCNT', cashAccnt);
							
						})
						Ext.each(dr_data, function(item){
							item.set('P_ACCNT', cashAccnt);
							
						})
					}
				})
				
				return rtn;
			},
			checkDivi:function() {
				var insertRecords=this.getNewRecords( );
				var updateRecords=this.getUpdatedRecords( );
				var removedRecords=this.getRemovedRecords( );
				
				var changedRec = [].concat(insertRecords).concat(updateRecords).concat(removedRecords);
				var rtn = true;
				var store = this;
				Ext.each(changedRec, function(rec) {					
					var slip_data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== rec.get("AC_DAY") && record.get('SLIP_NUM')== rec.get("SLIP_NUM") ) } ).items);		
					for(var i=0; i < slip_data.length-1; i++) {
						if((slip_data[i].get("SLIP_DIVI") =="1" || slip_data[i].get("SLIP_DIVI") == "2") && slip_data[i].get("SLIP_DIVI") != slip_data[i+1].get("SLIP_DIVI")) {
							alert(Msg.sMA0053);
							return false;
						}else if((slip_data[i].get("SLIP_DIVI") =="3" || slip_data[i].get("SLIP_DIVI") == "4") && (slip_data[i+1].get("SLIP_DIVI") =="1" || slip_data[i+1].get("SLIP_DIVI") == "2") ) {
							alert(Msg.sMA0053);
							return false;
						}
					}
				})
				return true;
			},
			slipGridChange:function(){
				var grid = masterGrid1;
				grid = UniAppManager.app.getActiveGrid();
				var record = grid.getSelectedRecord();
				if(record){
					var acDate = record.get('AC_DAY'), slopNo = record.get('SLIP_NUM');
					if(!Ext.isEmpty(acDate) && !Ext.isEmpty(slopNo) ) {
						slipStore1.loadStoreRecords(this, acDate,  slopNo);
						slipStore2.loadStoreRecords(this, acDate,  slopNo);
					}else {
						slipStore1.loadData({})
						slipStore2.loadData({})
					}
				}
			},
			checkSupplySum:function(salesSupplyAmt, salesTaxAmt, proofKind) {
				var rtn = true;
				
				var acSuppyAmt=0;
				var acTaxAmt=0;
				var drSum = 0;				
				var rtn = true;
				var store = this;
				var spec_data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('SPEC_DIVI') == 'F1' || record.get('SPEC_DIVI') == 'F2') } ).items);		
				var dr_data = Ext.Array.push(store.data.filterBy(function(record) {return ( record.get('DR_CR') == '1') } ).items);		
				 
				Ext.each(spec_data, function(item){
					for(var i=1; i <=6; i++) {
						if(item.get('AC_CODE'+i.toString()) == 'I1') {
							var amt = item.get('AC_DATA'+i.toString())
							if(amt){
								acSuppyAmt += parseInt(amt);
							}
						}
						if(item.get('AC_CODE'+i.toString()) == 'I6') {
							var tax = item.get('AC_DATA'+i.toString())
							if(tax){
								acTaxAmt += parseInt(tax);
							}
						}
					}
				})
				
				Ext.each(dr_data, function(item){
					drSum += item.get("AMT_I");
				})	
				
				console.log("drSum :", drSum, ", salesSupplyAmt :", salesSupplyAmt,", salesTaxAmt :", salesTaxAmt, ", acSuppyAmt :", acSuppyAmt,", acTaxAmt :", acTaxAmt);
				
				if(proofKind == '56') {
					if(drSum != salesTaxAmt) {
						if(!confirm(Msg.sMA0130+'\n'+ Msg.sMB061)) {
							rtn = false;
						}
					}
				}
				
				if(drSum != (salesSupplyAmt + salesTaxAmt).toFixed(6) || salesSupplyAmt !=acSuppyAmt || salesTaxAmt != acTaxAmt) {
					if(!confirm(Msg.sMA0130+'\n'+ Msg.sMB061)) {
						rtn = false;
					}
				}
				
				
				return rtn;
			},
			listeners:{
				load:function( store, records, successful, operation, eOpts ) {
					if(records == null || records.length == 0) {
						//gsDraftCode   = "N"
						gsDraftCode   = ""
						
						gsInputDivi = csINPUT_DIVI;	
						if(csINPUT_DIVI == "2") {
							if(slipForm  != 'undefined') {
								slipForm.getField('SLIP_DIVI').setReadOnly(false);
							}
						}
					}else {
						// 번호별 입력에서 데이타 입력/조회 된 후 전표구분 readOnly
						if(csINPUT_DIVI == "2") {
							if(slipForm  != 'undefined') {
								slipForm.getField('SLIP_DIVI').setReadOnly(true);
							}
						}
					}
					
					var count = masterGrid1.getStore().getCount();  
					if(count > 0){
						Ext.getCmp('GW').setDisabled(false);
					}else{
						Ext.getCmp('GW').setDisabled(true);
						slipForm.setValue('DRAFT_CODE', '');
					}
				},
				add:function( store, records, index, eOpts ) {
				},
				update:function( store, record, operation, modifiedFieldNames, details, eOpts) {	
					if(record.get("DR_CR") == "1" && record.get("SPEC_DIVI") =="F1" ) {
						var acCd_Idx = UniAccnt.findAcCode(record,"E2" );
						if(!Ext.isEmpty(acCd_Idx)) {
							var currentIdx = store.indexOf(record);
							if(currentIdx > 0) {
								var preRecord = store.getAt(currentIdx-1);
								record.set("AC_DATA"+acCd_Idx.toString(), preRecord.get("ACCNT"))
								record.set("AC_DATA_NAME"+acCd_Idx.toString(), preRecord.get("ACCNT_NAME"))
							}
						}
					}
					//공급가액(I1)
					if(UniUtils.indexOf('SPEC_DIVI', modifiedFieldNames) && (record.get("SPEC_DIVI") =="F1" || record.get("SPEC_DIVI") =="F2")) {
						
						var currentIdx = store.indexOf(record);
						var prevRecord = store.getAt(currentIdx-1);
						if(prevRecord) {
							UniAppManager.app.fnSetAcCode(record, "I1", prevRecord.get("AMT_I"));	// 공급가액
						}
					}
					// 세액(I6)
					if(UniUtils.indexOf('AMT_I', modifiedFieldNames) && (record.get("SPEC_DIVI") =="F1" || record.get("SPEC_DIVI") =="F2")) {
						UniAppManager.app.fnSetAcCode(record, "I6", record.get("AMT_I"));	// 세액
					}
					if(UniUtils.indexOf('CUSTOM_NAME', modifiedFieldNames)) {
						if(record.get('CUSTOM_NAME') == '')		{
							record.set('CUSTOM_CODE','');
						}
					}
					
					this.slipGridChange();				
				},
				datachanged:function( store,  eOpts ) {
					// 번호별 입력에서 데이타 입력/조회 된 후 전표구분 readOnly
					if(csINPUT_DIVI == "2") {
						if(slipForm  != 'undefined') {
							slipForm.getField('SLIP_DIVI').setReadOnly(true);
						}
					}
					this.slipGridChange();
				},
				remove:function( store, records, index, isMove, eOpts ) {
				}
			}
		}
		return config;
	}


  /**
   * 일발전표 Master Grid 정의(Grid Panel)
   * @param {} store  store Object
   * @param {} gridID	grid Id
   * @param {} detailFormID 관리항목 Form
   * @param {} sflex	Grid 높이 flex
   * @param {} isTbar	tbar 사용유무
   * @param {} gridType  1: 결의일반전표 , 2:결의전표번호별, 3:회계전표, 4 회계전표번호별
   * @return {}
   */
	function getGridConfig(store, gridID,	detailFormID, sflex, isTbar, gridType) {
		var hideForRegulaer = true;
		var hideForNum = false;
		if(gridType == '2' || gridType == '4') {
			hideForRegulaer = false;
			hideForNum= true
		}
		var gridConfig = {
			flex:sflex,
			accntType:gridType,
			uniOpt:{
				copiedRow:true,
				useContextMenu:false,
				expandLastColumn: false,
				useMultipleSorting: false,
				useNavigationModel:false,
				nonTextSelectedColumns:['REMARK']
			},
			enableColumnHide :false,
			sortableColumns : false,
			border:true,
			tbar: [{
				itemId : 'GWBtn',
				id:'GW',
				iconCls : 'icon-referance'  ,
				text:'기안',
				hidden:gwValue ,
				
				handler: function() {
					var param = panelResult.getValues();
					if(!UniAppManager.app.isValidSearchForm()){
						return false;
					}
					if(confirm('기안 하시겠습니까?')) {
						UniAppManager.app.requestApprove();
					}
				}
			}],
			store: store,
			columns:[
				 { dataIndex: 'AC_DAY'			,width: 45 , align:'center' ,hidden:hideForNum} 
//				,{ dataIndex: 'AC_DATE'			,width: 55 , align:'center'} 
				,{ dataIndex: 'SLIP_NUM'		,width: 55 , format:'0', align:'center',hidden:hideForNum} 
				,{ dataIndex: 'SLIP_SEQ'		,width: 45 , align:'center'} 
				,{ dataIndex: 'DR_CR'			,width: 80 ,hidden:hideForRegulaer} 
				,{ dataIndex: 'SLIP_DIVI'		,width: 80 ,hidden:hideForNum} 
				,{ dataIndex: 'ACCNT'			,width: 80 ,
					editor:Unilite.popup('ACCNT_AC_G', {
						autoPopup: true,
						textFieldName:'ACCNT',
						DBtextFieldName: 'ACCNT_CODE',
						listeners:{
							scope:this,
							onSelected:function(records, type ) {
								var aGridID = gridID, aDetailFormID=detailFormID;
								var grid = Ext.getCmp(aGridID);
								var form = Ext.getCmp(aDetailFormID);
								grid.uniOpt.currentRecord.set('ACCNT', records[0].ACCNT_CODE);
								grid.uniOpt.currentRecord.set('ACCNT_NAME', records[0].ACCNT_NAME);
								//UniAppManager.app.setAccntInfo(grid.uniOpt.currentRecord, form )
								
								UniAppManager.app.loadDataAccntInfo(grid.uniOpt.currentRecord, form, records[0])
							},
							onClear:function(type) {
								var aGridID = gridID, aDetailFormID=detailFormID;
								var grid = Ext.getCmp(aGridID);
								var form = Ext.getCmp(aDetailFormID);
								UniAppManager.app.clearAccntInfo(grid.uniOpt.currentRecord, form);
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
									var param = {
										'RDO': '3',
										'TXT_SEARCH': popup.textField.getValue(),
										'CHARGE_CODE':panelSearch.getValue('CHARGE_CODE'),
										'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
									}
									popup.setExtParam(param);
								}
							}
						}
					})
				} 
				,{ dataIndex: 'ACCNT_NAME'		,width: 130 ,
					editor:Unilite.popup('ACCNT_AC_G', {
						autoPopup: true,
						listeners:{
							scope:this,
							onSelected:function(records, type ) {
								var aGridID = gridID, aDetailFormID=detailFormID;
								var grid = Ext.getCmp(aGridID);
								var form = Ext.getCmp(aDetailFormID);
								grid.uniOpt.currentRecord.set('ACCNT', records[0].ACCNT_CODE);
								grid.uniOpt.currentRecord.set('ACCNT_NAME', records[0].ACCNT_NAME);
								//UniAppManager.app.setAccntInfo(grid.uniOpt.currentRecord, form)
								UniAppManager.app.loadDataAccntInfo(grid.uniOpt.currentRecord, form, records[0]);
							},
							onClear:function(type) {
								var aGridID = gridID, aDetailFormID=detailFormID;
								var grid = Ext.getCmp(aGridID);
								var form = Ext.getCmp(aDetailFormID);
								UniAppManager.app.clearAccntInfo(grid.uniOpt.currentRecord, form);
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){
							
								var param = {
									'RDO': '4',
									'TXT_SEARCH': popup.textField.getValue(),
									'CHARGE_CODE':panelSearch.getValue('CHARGE_CODE'),
									'ADD_QUERY':"SLIP_SW = N'Y' AND GROUP_YN = N'N'"
								}
								popup.setExtParam(param);
								}
							}
						}
					})} 
				,{ dataIndex: 'CUSTOM_CODE'		,width: 80,
					'editor' : Unilite.popup('CUST_G',{
						textFieldName:'CUSTOM_CODE',
						DBtextFieldName:'CUSTOM_CODE',
						autoPopup: true,
						extParam:{"CUSTOM_TYPE":['1','2','3']},
						listeners: {
							'onSelected':  function(records, type  ){
								var aGridID = gridID, aDetailFormID=detailFormID;
								var grid = Ext.getCmp(aGridID);
								var form = Ext.getCmp(aDetailFormID);
								var grdRecord = grid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								for(var i=1 ; i <= 6 ; i++) {
									if(grdRecord.get("AC_CODE"+i.toString()) == 'A4') {
										grdRecord.set('AC_DATA'+i.toString()		,records[0]['CUSTOM_CODE']);
										grdRecord.set('AC_DATA_NAME'+i.toString()	,records[0]['CUSTOM_NAME']);
									
										form.setValue('AC_DATA'+i.toString()		,records[0]['CUSTOM_CODE']);
										form.setValue('AC_DATA_NAME'+i.toString()	,records[0]['CUSTOM_NAME']);
									
									}else if(grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
										grdRecord.set('AC_DATA'+i.toString()		,records[0]['BOOK_CODE']);
										grdRecord.set('AC_DATA_NAME'+i.toString()	,records[0]['BOOK_NAME']);
										
										form.setValue('AC_DATA'+i.toString()		,records[0]['BOOK_CODE']);
										form.setValue('AC_DATA_NAME'+i.toString()	,records[0]['BOOK_NAME']);
									
									}
								}
								//form.setActiveRecord(grdRecord);
							},
							'onClear':  function( type  ){
								var aGridID = gridID, aDetailFormID=detailFormID;
								var grid = Ext.getCmp(aGridID);
								var form = Ext.getCmp(aDetailFormID);
								var grdRecord = grid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_NAME','');
								grdRecord.set('CUSTOM_CODE','');
								for(var i=1 ; i <= 6 ; i++) {
									if(grdRecord.get("AC_CODE"+i.toString()) == 'A4' || grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
										grdRecord.set('AC_DATA'+i.toString()		,'');
										grdRecord.set('AC_DATA_NAME'+i.toString()	,'');
										
										form.setValue('AC_DATA'+i.toString()		,'');
										form.setValue('AC_DATA_NAME'+i.toString()	,'');
									}
								}
								//form.setActiveRecord(grdRecord);
							}
						} // listeners
					})
				 } 
				,{ dataIndex: 'CUSTOM_NAME'		,width: 140 ,
					'editor' : Unilite.popup('CUST_G',{
						textFieldName:'CUSTOM_NAME',
						validateBlank:false,
						autoPopup: true,
						extParam:{"CUSTOM_TYPE":['1','2','3']},
						listeners: {
							'onSelected':  function(records, type  ){
								var aGridID = gridID, aDetailFormID=detailFormID;
								var grid = Ext.getCmp(aGridID);
								var form = Ext.getCmp(aDetailFormID);
								
								var grdRecord = grid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
								for(var i=1 ; i <= 6 ; i++) {
									if(grdRecord.get("AC_CODE"+i.toString()) == 'A4') {
										grdRecord.set('AC_DATA'+i.toString()		,records[0]['CUSTOM_CODE']);
										grdRecord.set('AC_DATA_NAME'+i.toString()	,records[0]['CUSTOM_NAME']);
										
										form.setValue('AC_DATA'+i.toString()		,records[0]['CUSTOM_CODE']);
										form.setValue('AC_DATA_NAME'+i.toString()	,records[0]['CUSTOM_NAME']);
									}else if(grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
										grdRecord.set('AC_DATA'+i.toString()		,records[0]['BOOK_CODE']);
										grdRecord.set('AC_DATA_NAME'+i.toString()	,records[0]['BOOK_NAME']);
										
										form.setValue('AC_DATA'+i.toString()		,records[0]['BOOK_CODE']);
										form.setValue('AC_DATA_NAME'+i.toString()	,records[0]['BOOK_NAME']);
									}
								}
								//form.setActiveRecord(grdRecord);
							},
							'onClear':  function( type  ){
								var aGridID = gridID, aDetailFormID=detailFormID;
								var grid = Ext.getCmp(aGridID);
								var form = Ext.getCmp(aDetailFormID);
								
								var grdRecord = grid.uniOpt.currentRecord;
								grdRecord.set('CUSTOM_CODE','');
								for(var i=1 ; i <= 6 ; i++) {
									if(grdRecord.get("AC_CODE"+i.toString()) == 'A4' || grdRecord.get("AC_CODE"+i.toString()) == 'O2') {
										grdRecord.set('AC_DATA'+i.toString()		,'');
										grdRecord.set('AC_DATA_NAME'+i.toString()	,'');
										
										form.setValue('AC_DATA'+i.toString()		,'');
										form.setValue('AC_DATA_NAME'+i.toString()	,'');
									}
								}
								//form.setActiveRecord(grdRecord);
							}
						} // listeners
					})
				 }
				,{ dataIndex: 'DR_AMT_I'		,width: 100}
				,{ dataIndex: 'CR_AMT_I'		,width: 100}
				,{ dataIndex: 'REMARK'			,width: 200 ,
//					renderer:function(value, metaData, record) {
//						var r = value;
//						if(record.get('POSTIT_YN') == 'Y') r ='<img src="'+CPATH+'/resources/images/PostIt.gif"/>'+value
//						return r;
//					},
					editor:Unilite.popup('REMARK_G',{
						textFieldName:'REMARK',
						validateBlank:false,
						autoPopup: false,
						listeners:{
							'onSelected':function(records, type) {
								var aGridID = gridID;
								var grid = Ext.getCmp(aGridID);
								var selectedRec = grid.getSelectedRecord();// masterGrid1.uniOpt.currentRecord;
								selectedRec.set('REMARK', records[0].REMARK_NAME);
								
							},
							'onClear':function(type) {
								var aGridID = gridID;
								var grid = Ext.getCmp(aGridID);
								var selectedRec = grid.getSelectedRecord();
								//selectedRec.set('REMARK', '');
							},
							applyExtParam:{
								scope:this,
								fn:function(popup){		
									var aGridID = gridID;
									var grid = Ext.getCmp(aGridID)
								var param = {
									'ACCNT': Unilite.nvl(grid.uniOpt.currentRecord.get("ACCNT"), ''),
									'DR_CR': Unilite.nvl(grid.uniOpt.currentRecord.get("DR_CR"), '')
								}
								popup.setExtParam(param);
								}
							}
							
						}
						
					})
				} 
				,{ dataIndex: 'SPEC_DIVI'	,width: 110 , hidden:true}
				,{ dataIndex: 'PROOF_KIND'	,width: 110 
				  ,editor:{
						xtype:'uniCombobox',
						store:Ext.data.StoreManager.lookup('CBS_AU_A022'),
						listeners:{
							beforequery:function(queryPlan, value) {
								var aGridID = gridID;
								var grid = Ext.getCmp(aGridID);
								
								this.store.clearFilter();
								if(grid.uniOpt.currentRecord.get('SPEC_DIVI') == 'F1') {
									this.store.filterBy(function(record){return record.get('refCode3') == '1'},this)
								}else if(grid.uniOpt.currentRecord.get('SPEC_DIVI') == 'F2') {
									this.store.filterBy(function(record){return record.get('refCode3') == '2'},this)
								}
							}
						}
					}
				} 
				,{ dataIndex: 'CREDIT_NUM'		,width: 150 , hidden: true} 
				,{ dataIndex: 'CREDIT_NUM_MASK'		,width: 150 }
				,{ dataIndex: 'DEPT_NAME'		,width: 100 ,
					editor:Unilite.popup('DEPT_G',{
						showValue:false,
						extParam:{'TXT_SEARCH':'', 'isClearSearchTxt':baseInfo.inDeptCodeBlankYN == 'Y' ? true : false},
						autoPopup: true,
						listeners:{
							'onSelected':function(records, type) {
								var aGridID = gridID;
								var grid = Ext.getCmp(aGridID);
								var selectedRec = grid.uniOpt.currentRecord;
								selectedRec.set('DEPT_NAME', records[0].TREE_NAME);
								selectedRec.set('DEPT_CODE', records[0].TREE_CODE);
								selectedRec.set('DIV_CODE', records[0].DIV_CODE);
								selectedRec.set('BILL_DIV_CODE', records[0].BILL_DIV_CODE);
							},
							'onClear':function(type) {
								var aGridID = gridID;
								var grid = Ext.getCmp(aGridID);
								var selectedRec = grid.uniOpt.currentRecord;
								selectedRec.set('DEPT_NAME', '');
								selectedRec.set('DEPT_CODE', '');
								selectedRec.set('DIV_CODE', '');
								selectedRec.set('BILL_DIV_CODE', '');
							}
						}
						
					})
				 }
				,{ dataIndex: 'DIV_CODE'		,flex: 1 , minWidth:60} 
				,{ dataIndex: 'REPORT_TYPE'		,width: 150 , hidden: true}
				,{ dataIndex: 'REMARK2'			,width: 150 , hidden: true}
				,{ dataIndex: 'DRAFT_CODE'		,width: 150 , hidden: true}
				,{ dataIndex: 'DRAFT_NO'		,width: 150 , hidden: true}
				,{ dataIndex: 'GW_DOC'			,width: 150 , hidden: true}
				,{ dataIndex: 'OLD_ACCNT'		,width: 100 , hidden: true} 

			  ] ,
			listeners:{
				render:function(grid, eOpt) {
					grid.getEl().on('click', function(e, t, eOpt) {
						activeGrid = grid.getItemId();
					});
					var b = isTbar;
					var copyIcon = (gridType == '2' || gridType == '4') ? true : false
					var i=0;
					if(b) {
						i=0;
					}
					var tbar = grid._getToolBar();
					if(b) {
						tbar[0].insert(i++,{
								xtype: 'uniBaseButton',
								iconCls: 'icon-getauto',
								width: 26, height: 26,
								tooltip:'자동분개 불러오기',
								handler:function() {
									masterGrid1.getStore().clearFilter();
									//openPostIt();
								}
						});
						tbar[0].insert(i++,{
								xtype: 'uniBaseButton',
								iconCls: 'icon-saveauto',
								width: 26, height: 26,
								tooltip:'자동분개 등록하기',
								handler:function() {
									//openPostIt();
								}
						});
					}
					if(copyIcon) {
						tbar[0].insert(i++,{
								xtype: 'uniBaseButton',
								iconCls: 'icon-copySlip',
								width: 26, height: 26,
								tooltip:'전표복사',
								handler:function() {
									UniAppManager.app.fnCopySlip();
								}
						});
					}
					tbar[0].insert(i++,{
							xtype: 'uniBaseButton',
							iconCls: 'icon-saveRemark',
							width: 26, height: 26,
							tooltip:'적요 등록하기',
							handler:function() {
								var grid = Ext.getCmp(gridID);
								var record = grid.getSelectedRecord();
								if(!Ext.isEmpty(record)) { 
									var param = {
										'ACCNT'			: record.get('ACCNT'),
										'ACCNT_NAME'	: record.get('ACCNT_NAME'),
										'DR_CR'			: record.get('DR_CR'),
										'REMARK'		: record.get('REMARK')
									};
									var rec1 = {data : {prgID : 'aba700ukr', 'text':''}};
									parent.openTab(rec1, '/accnt/aba700ukr.do', param, CHOST+CPATH);
								}
							}
					});tbar[0].insert(i++,{
							xtype: 'uniBaseButton',
							iconCls: 'icon-postit',
							width: 26, height: 26,
							tooltip:'각주',
							handler:function() {
								openPostIt(grid);
							}
					});
				},
				selectionChange: function( grid, selected, eOpts ) {
					if(selected.length == 1) {
						gsDraftCode = selected[0].get('DRAFT_CODE');
						gsInputDivi = selected[0].get('INPUT_DIVI');
						gsInputPath = selected[0].get('INPUT_PATH');
						var grdType = gridType;
						var fName, acCode, acName, acType, acPopup, acLen, acCtl, acFormat;
						var dataMap = selected[0].data;
						/**
						 * masterGrid의 ROW를 select할때마다 동적 필드 생성 최대 6개까지 생성 생성된 필드가
						 * 팝업일시 필드name은 아래와 같음 valueFieldName textFieldName
						 * AC_DATA1(~6) AC_DATA_NAME1(~6)
						 * --------------------------------------------------------------------------
						 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드
						 * name은 아래와 같음 AC_DATA1(~6)
						 */
						var aDetailFormID=detailFormID;
						var form = Ext.getCmp(aDetailFormID);
						var selectedRecord = Ext.isEmpty(selected)?null:selected[0];
						var prevRecord, store = grid.getStore();
						selectedIdx = store.indexOf(selectedRecord)
						if(selectedIdx >0) prevRecord = store.getAt(selectedIdx-1);

						UniAccnt.addMadeFields(form, dataMap, form, '', Ext.isEmpty(selected)?null:selected[0], prevRecord);
						form.setActiveRecord(selected[0]);

						if(grdType=="1" || grdType=="2" ) {
							if(selected[0].get('AP_STS') == "2") {
								if(Ext.isFunction(UniAppManager.app.setEditableGrid) )	UniAppManager.app.setEditableGrid( null, false);
								form.setReadOnly(true);
							} else {
								if(Ext.isFunction(UniAppManager.app.setEditableGrid) )	UniAppManager.app.setEditableGrid( gsInputPath, false);
								//20200702 추가
								setTimeout(function(){UniAppManager.app.fnControlForm(selected[0])}, 100);
							}
						}else {
							if(Ext.isFunction(UniAppManager.app.setEditableGrid) )	 UniAppManager.app.setEditableGrid(  selected[0].get('INPUT_PATH'), true);
							//20200702 추가
							setTimeout(function(){UniAppManager.app.fnControlForm(selected[0])}, 100);
						}
						var activeTabId
						if(tab){
							var activeTab = tab.getActiveTab();
							activeTabId = activeTab.getItemId();
						}else {
							activeTabId ='agjTab1'
						}
						if(activeTabId =='agjTab1') {
							slipStore1.loadStoreRecords(grid.getStore(), dataMap['AC_DAY'], dataMap['SLIP_NUM']);
							slipStore2.loadStoreRecords(grid.getStore(), dataMap['AC_DAY'], dataMap['SLIP_NUM']);
						}
						//spec_divi = 'F1', 'F2' 인 경우 관리항목으로 focus 이동해야 하므로 wasSpecDiviFocus 값 초기화
						wasSpecDiviFocus = false;
					} else {
						//detailForm1.clearForm();
						if(detailForm1 && detailForm1.down('#formFieldArea1') ) {
							detailForm1.down('#formFieldArea1').removeAll();
						}
						//saleDetailForm.clearForm();
						var sForm = Ext.getCmp("agj100ukrSaleDetailForm");
						if(sForm && sForm.down('#formFieldArea1') ) {
							sForm.down('#formFieldArea1').removeAll();
						}
						var sForm1 = Ext.getCmp("agj100ukrSaleDetailForm");
						if(sForm1 && sForm1.down('#formFieldArea1') ) {
							sForm1.down('#formFieldArea1').removeAll();
						}
						var sForm2 = Ext.getCmp("agj200ukrSaleDetailForm");
						if(sForm2 && sForm2.down('#formFieldArea1') ) {
							sForm2.down('#formFieldArea1').removeAll();
						}
						drSum = 0; crSum = 0;
						slipGrid1.reset();
						slipGrid2.reset();
					}
				},
				beforeedit:function( editor, context, eOpts ) {
					if(context.record.get("OLD_ACCNT") == '19999') {
						return true;
					}
					if(context.record.get("DRAFT_CODE") == '3') {
						return false;
					}
					if(slipForm.getValue('DRAFT_CODE') == '3') {
						return false;
					}
					if(context.record.get("DRAFT_CODE") == '1') {
						return false;
					}
					if(slipForm.getValue('DRAFT_CODE') == '1') {
						return false;
					}
					if(context.field == "CR_AMT_I" && context.record.get("DR_CR") == '1') {
						return false;
					}else if(context.field == "CR_AMT_I" && context.record.get("FOR_YN") == "Y") {
						if(context.record.get("CR_AMT_I") == 0) {
							openForeignCur(context.record, "CR_AMT_I");
							return false;
						}
					}
					if(context.field == "DR_AMT_I" && context.record.get("DR_CR") == '2') {
						return false;
					}else if(context.field == "DR_AMT_I" && context.record.get("FOR_YN") == "Y") {
						if(context.record.get("DR_AMT_I") == 0) {
							openForeignCur(context.record, "DR_AMT_I");
							return false;
						}
					}
					if(context.field == "PROOF_KIND" && !(context.record.get("SPEC_DIVI") == 'F1' || context.record.get("SPEC_DIVI") == 'F2')) {
						return false;
					}
					if(context.grid.ownerGrid.accntType == '1' || context.grid.ownerGrid.accntType == '2') {
						if(context.record.get('AP_STS') == '2' && context.field != "REMARK") {
							return false;
						}
					}
					if(!tempEditMode) {
						if(context.field != "REMARK" ) {
							return false;
						}
					}
					if(Ext.isFunction(UniAppManager.app.isEditField) ) {
						return UniAppManager.app.isEditField(context.field);
					}
					/*if(context.record.get("DRAFT_CODE") == '1' || context.record.get("DRAFT_CODE") == '3') {
						return false;	
					}
					if(slipForm.getValue('DRAFT_CODE') == '1' || slipForm.getValue('DRAFT_CODE') == '3') {
						return false;	
					}*/
				},
				celldblclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
//					if(e.position.column.dataIndex=='CREDIT_NUM') {
//						UniAppManager.app.fnProofKindPopUp(record);
//						//creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM'), "CREDIT_NUM", null, null, null, null,  'VALUE');
//					}
					if(e.position.column.dataIndex=='CREDIT_NUM_EXPOS' || e.position.column.dataIndex=='CREDIT_NUM_MASK' ) {
						UniAppManager.app.fnProofKindPopUp(record);
						//creditWIn = creditPopup (creditWIn, record, record.get('CREDIT_NUM'), "CREDIT_NUM", null, null, null, null,  'VALUE');
					}
					if(e.position.column.dataIndex=='PROOF_KIND') {
						UniAppManager.app.fnProofKindPopUp(record);
					}
					if(e.position.column.dataIndex== "CR_AMT_I" && record.get("DR_CR") == '2' && record.get("FOR_YN") == "Y") {
						openForeignCur(record, "CR_AMT_I");
					}
					if(e.position.column.dataIndex== "DR_AMT_I" && record.get("DR_CR") == '1'  && record.get("FOR_YN") == "Y") {
						openForeignCur(record, "DR_AMT_I");
					}
				},
/*				onGridDblClick:function(grid, record, cellIndex, colName, td) {
					if(colName =="CREDIT_NUM_EXPOS") {  
						grid.ownerGrid.openCryptCardNoPopup(record); 
					}
				},
				openCryptCardNoPopup:function( record ) {
					if(record) {
						var params = {'CRDT_FULL_NUM': record.get('CREDIT_NUM'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'Y'}
						Unilite.popupCipherComm('grid', record, 'CREDIT_NUM_EXPOS', 'CREDIT_NUM', params);
					}
						
				},	*/
				cellkeydown:function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
					//pause key(19) 입력시 금액 자동 계산
					var keyCode = e.getKey();
					var colName = e.position.column.dataIndex;
					//PAUSE key
					if(keyCode == 19 && (colName == 'CR_AMT_I' || colName == 'DR_AMT_I' ) ) {		
						if(record.get("DR_CR") == '1' && colName == 'DR_AMT_I') {
							var amtI = slipStore1.sum('AMT_I') + slipStore2.sum('AMT_I') - slipStore1.sum('AMT_I');
							record.set(colName, amtI);	 
							record.set('AMT_I', amtI);	 
							view.getStore().slipGridChange();
						}else if(record.get("DR_CR") == '2' && colName == 'CR_AMT_I'){
							var amtI = slipStore2.sum('AMT_I') + slipStore1.sum('AMT_I') - slipStore2.sum('AMT_I');
							record.set(colName, amtI);	
							record.set('AMT_I', amtI);	 
							view.getStore().slipGridChange();
						}
					}
					if(keyCode == 13) {
						enterNavigation(e);
					}
//					if(keyCode == e.F8 && colName == 'CREDIT_NUM') {
//						UniAppManager.app.fnProofKindPopUp(record);
//					}
					if(keyCode == e.F8 && colName == 'CREDIT_NUM_EXPOS') {
						UniAppManager.app.fnProofKindPopUp(record);
					}
				}
			}
		}
		console.log("gridConfig:",gridConfig);
		return gridConfig;
	}

	function getAcFormConfig(itemId, grid) {
		var formConfig = {		
				itemId: itemId,
				masterGrid: grid,
				height: 90,
				disabled: false,
				border: true,
				padding: '1',
				layout : 'hbox',
				items:[{
					xtype: 'container',
					itemId: 'formFieldArea1',
					layout: {
						type: 'uniTable', 
						columns:3			//20200716 수정: 관리항목이 6개일 때, 합계 금액 표시 위해 변경(2 -> 3)
					},
					defaults:{
						width:365,
						labelWidth: 130
					}
				}]
			}
		return formConfig;
	}
	
	function openCrediNotWin(record) {
		if(record){
			if(!creditNoWin) {
					creditNoWin = Ext.create('widget.uniDetailWindow', {
						title: '현금영수증번호',
						width: 300,
						height:140,
						layout: {type:'vbox', align:'stretch'},
						items: [{
								itemId:'search',
								xtype:'uniSearchForm',
								style:{
									'background':'#fff',
									'width':'300px'
								},
								margine:'3 3 3 3',
								items:[
									{
										xtype:'component',
										html:' <div style="line-height:30px;"> * 번호를 입력하십시오.</div>'
									},
									{	
										hideLabel:true,
										height:28,
										//labelWidth:60,
										name :'CREDIT_NUM',
										width:275
									},{
										fieldLabel: '복호화',
										name:'DECRYP_WORD',
										hidden: true
									},
									{
										fieldLabel: '암호화',
										name:'INCRYP_WORD',
										hidden: true
									},{
										fieldLabel: '암호화구분',
										name:'INCDRC_GUBUN',
										hidden: true
									}
								]
							}
						],
						tbar:  [
							 '->',{
								itemId : 'submitBtn',
								text: '확인',
								handler: function() {
									var form = creditNoWin.down('#search');
									var creditNum = creditNoWin.down('#search').getValue('CREDIT_NUM');
									
//									if(creditNum && creditNum.length > 0) {
//										creditNoWin.rtnRecord.set('CREDIT_NUM', creditNum );
//									}
//									creditNoWin.hide();
									
									if(Ext.isEmpty(creditNum)){
										//form.setValue('INCRYP_WORD', '');
										//creditNoWin.rtnRecord.set('CREDIT_NUM', creditNum );
										alert('카드번호/현금영수증 번호를 입력하세요.');
										//creditNoWin.hide();
									}else{
										form.setValue('DECRYP_WORD', creditNum);
										form.setValue('INCDRC_GUBUN',  'INC');
										
										creditNoWin.fnIncryptDecrypt();
									}
								},
								disabled: false
							},{
								itemId : 'closeBtn',
								text: '닫기',
								handler: function() {
									creditNoWin.hide();
								},
								disabled: false
							}
						],
						listeners : {beforehide: function(me, eOpt) {
										creditNoWin.down('#search').clearForm();
									},
									beforeclose: function( panel, eOpts ) {
										creditNoWin.down('#search').clearForm();
									},
									show: function( panel, eOpts ) {
										var form = creditNoWin.down('#search');
										//form.setValue('CREDIT_NUM', creditNoWin.rtnRecord.get('CREDIT_NUM'));
										
										//var frm = me.panelSearch;
										//if(!Ext.isEmpty(param.DECRYP_WORD))	frm.setValue('DECRYP_WORD', param.DECRYP_WORD);
										
										//alert(param['CRDT_FULL_NUM']);
										if(!Ext.isEmpty(creditNoWin.rtnRecord.get('CREDIT_NUM'))){
											form.setValue('INCDRC_GUBUN', 'DEC');
											form.setValue('INCRYP_WORD', creditNoWin.rtnRecord.get('CREDIT_NUM'));
											//alert(creditNoWin.rtnRecord.get('CREDIT_NUM'));
											creditNoWin.fnIncryptDecrypt();
										}
										//creditNoWin._dataLoad();
									}
						},
						fnIncryptDecrypt: function() {	
							//var me = this;
							//var param= me.panelSearch.getValues();
							
							var form = creditNoWin.down('#search');
							var param = creditNoWin.down('#search').getValues();
							
							popupService.incryptDecryptPopup(param, function(provider, response) {
								if(!Ext.isEmpty(provider)){
									//alert(provider);
									if(form.getValue('INCDRC_GUBUN') == 'INC'){
										form.setValue('INCRYP_WORD', provider);
										creditNoWin.rtnRecord.set('CREDIT_NUM', provider);	
										creditNoWin.hide();
									}else{
										form.setValue('CREDIT_NUM', provider);
										form.setValue('DECRYP_WORD', provider);
									}
								}
							})
						}
					});
			}
			creditNoWin.rtnRecord = record;
			creditNoWin.center();
			creditNoWin.show();
		}
	}
	function creditPopup (popupWin, returnRecord, searchTxt, codeColName, nameColName, creditNum, companyColName, companyNmColName, rateColNme,  rdoType) { 
		if(!popupWin) {
				Unilite.defineModel('creditModel', {
					fields: [
								 {name: 'CRDT_NUM'			,text:'신용카드코드'			,type:'string'	}
								,{name: 'CRDT_NAME'		,text:'카드명'				,type:'string'	}
								,{name: 'CRDT_FULL_NUM_MASK'	,text:'신용카드번호'			,type:'string', defaultValue: '***************'}
								,{name: 'CRDT_FULL_NUM_EXPOS'	,text:'신용카드번호'			,type:'string'	}
								,{name: 'CRDT_FULL_NUM'	,text:'신용카드번호(DB)'			,type:'string'	}
								,{name: 'BANK_CODE'		,text:'은행코드'				,type:'string'	}
								,{name: 'BANK_NAME'		,text:'은행명'				,type:'string'	}
								,{name: 'ACCOUNT_NUM_MASK' ,text:'결제계좌번호'			,type:'string', defaultValue: '***************'}
								,{name: 'ACCOUNT_NUM_EXPOS' ,text:'결제계좌번호'			,type:'string'	}
								,{name: 'ACCOUNT_NUM'		,text:'결제계좌번호(DB)'			,type:'string'	}
								,{name: 'SET_DATE'			,text:'결제일'				,type:'uniDate'	}
								,{name: 'PERSON_NAME'		,text:'사원명'				,type:'string'	}
								,{name: 'CRDT_COMP_CD'		,text:'신용카드사'				,type:'string'	}
								,{name: 'CRDT_COMP_NM'		,text:'신용카드사명'			,type:'string'	}
								,{name: 'COMP_CODE'			,text:'법인코드'				,type:'string'	}
								
							]
				});
				var creditDirctProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
					api: {
						read : 'popupService.creditCard3'
					}
				});
				
				var creditStore = Unilite.createStore('creditStore', {
						model: 'creditModel' ,
						proxy: creditDirctProxy,			
						loadStoreRecords : function() {
							var param= popupWin.down('#search').getValues();	
							
							this.load({
								params: param
							});				
						}
				});
		
				popupWin = Ext.create('widget.uniDetailWindow', {
					title: '신용카드',
					width: 600,
					height:400,
					'returnRecord'		: returnRecord,
					'rdoType'			: rdoType,
					'searchTxt'		: searchTxt,
					'codeColName'		: codeColName,
					'nameColName'		: nameColName,
					'creditNum'			: creditNum,
					'companyColName'	: companyColName,
					'companyNmColName'	: companyNmColName,
					'rateColNme'		: rateColNme,
					
					layout: {type:'vbox', align:'stretch'},
					items: [{
							itemId:'search',
							xtype:'uniSearchForm',
							layout:{type:'uniTable',columns:2},
							items:[
								{
									
									hideLabel:true,
									xtype: 'radiogroup',
									width: 150,
									items:[	{inputValue: '1', boxLabel:'카드번호', name: 'RDO', checked: true},
											{inputValue: '2', boxLabel:'카드명',   name: 'RDO'} 
									]
								},
								{	
									fieldLabel:'검색어',
									labelWidth:60,
									name :'TXT_SEARCH',
									width:250
								},
								{ xtype: 'uniTextfield',	  name:'INCRYP_WORD', hidden: true},
								{ xtype: 'uniTextfield',	  name:'INCDRC_GUBUN', hidden: true}	
								
							]
						},
						Unilite.createGrid('', {
							itemId:'grid',
							layout : 'fit',
							store: creditStore,
							selModel:'rowmodel',
							uniOpt:{
								onLoadSelectFirst : true
							},
							columns:  [  
									 { dataIndex: 'CRDT_NUM'			,width: 80  }  
									,{ dataIndex: 'CRDT_NAME'			,width: 100 }  
									,{ dataIndex: 'CRDT_FULL_NUM_MASK'		,width: 140 } 
									,{ dataIndex: 'CRDT_FULL_NUM_EXPOS'	,width: 140, hidden: true } 
									,{ dataIndex: 'CRDT_FULL_NUM'		,width: 140, hidden: true }  
									,{ dataIndex: 'BANK_CODE'			,width: 80  }  
									,{ dataIndex: 'BANK_NAME'			,width: 80  }  	
									,{ dataIndex: 'ACCOUNT_NUM_MASK'		,width: 120 } 
									,{ dataIndex: 'ACCOUNT_NUM_EXPOS'		,width: 120, hidden: true }  
									,{ dataIndex: 'ACCOUNT_NUM'		,width: 120, hidden: true }  
									,{ dataIndex: 'SET_DATE'			,width: 80  }  
									,{ dataIndex: 'PERSON_NAME'			,width: 80  }  
									,{ dataIndex: 'CRDT_COMP_CD'		,width: 100 }  
									,{ dataIndex: 'CRDT_COMP_NM'		 ,width: 150}
							]
							,listeners: {
									onGridDblClick:function(grid, record, cellIndex, colName) {
										if(colName =="CRDT_FULL_NUM_MASK") {
											record.set('CRDT_FULL_NUM_MASK',record.data['CRDT_FULL_NUM_EXPOS']);
										}else if(colName =="ACCOUNT_NUM_MASK") {
											record.set('ACCOUNT_NUM_MASK',record.data['ACCOUNT_NUM_EXPOS']);
										}else {
											grid.ownerGrid.returnData();
											popupWin.hide();
										}
									},
									beforecelldblclick:function  (grid , td , cellIndex , record , tr , rowIndex , e , eOpts ) {
										var records = creditStore.data.items;
										Ext.each(records, function(record,i) {
											if(record.data['CRDT_FULL_NUM_MASK'] != '***************'){
												record.set('CRDT_FULL_NUM_MASK','***************');
											}
											if(record.data['ACCOUNT_NUM_MASK'] != '***************'){
												record.set('ACCOUNT_NUM_MASK','***************');
											}
										});
									}
							 }
							,returnData: function() {
								var record = this.getSelectedRecord();  
								if(Ext.isEmpty(record)) {
									alert(Msg.sMA0256);
									return false;
								}
								if(popupWin.codeColName) {
									popupWin.returnRecord.set(popupWin.codeColName, record.get("CRDT_NUM"));
								}
								if(popupWin.nameColName) {
									popupWin.returnRecord.set(popupWin.nameColName, record.get("CRDT_NAME"));
								}
								if(popupWin.creditNum) {
									popupWin.returnRecord.set(popupWin.creditNum, record.get("CRDT_FULL_NUM"));
									popupWin.returnRecord.set(popupWin.creditNum+'_EXPOS', record.get("CRDT_FULL_NUM_EXPOS"));
								}
								
								if(popupWin.companyColName) {
									popupWin.returnRecord.set(popupWin.companyColName, record.get("CRDT_COMP_CD"));
								}
								if(popupWin.companyNmColName) {
									popupWin.returnRecord.set(popupWin.companyNmColName, record.get("CRDT_COMP_NM"));
								}/*
								if(popupWin.rateColNme) {
									popupWin.returnRecord.set(popupWin.rateColNme, record.get("FEE_RATE"))
								}*/
								
							}
							
						})
						   
					],
					tbar:  ['->',
						 {
							itemId : 'searchtBtn',
							text: '조회',
							handler: function() {
								var form = popupWin.down('#search');
								var store = Ext.data.StoreManager.lookup('creditStore')
								creditStore.loadStoreRecords();
							},
							disabled: false
						},
						 {
							itemId : 'submitBtn',
							text: '확인',
							handler: function() {
								popupWin.down('#grid').returnData()
								popupWin.hide();
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								popupWin.hide();
							},
							disabled: false
						}
					],
					listeners : {beforehide: function(me, eOpt) {
									popupWin.down('#search').clearForm();
									popupWin.down('#grid').reset();
								},
								 beforeclose: function( panel, eOpts ) {
									popupWin.down('#search').clearForm();
									popupWin.down('#grid').reset();
								},
								 show: function( panel, eOpts ) {
									var form = popupWin.down('#search');
									form.clearForm();
									if(popupWin.rdoType == "TEXT") {
										form.setValue('RDO', '2');
										form.setValue('TXT_SEARCH', popupWin.returnRecord.get(popupWin.nameColName));
									}else {
										form.setValue('RDO', '1');
										if(popupWin.searchTxt) {
//											form.setValue('TXT_SEARCH', popupWin.returnRecord.get(popupWin.searchTxt));
											if(!Ext.isEmpty(popupWin.searchTxt)){
													form.setValue('INCDRC_GUBUN', 'DEC');
													form.setValue('INCRYP_WORD', popupWin.searchTxt);
															
													this.fnDecrypt();   //함수내에서 복호화후 조회
											}
											form.setValue('TXT_SEARCH', popupWin.searchTxt); // 카드번호/현금영수증 팝업 띄울시 팝업 SEARCH FIELD에  값 셋팅 안되는 문제 때문에 수정 20161219
										}else {
											form.setValue('TXT_SEARCH', popupWin.returnRecord.get(popupWin.codeColName));
										}
										
									}
									Ext.data.StoreManager.lookup('creditStore').loadStoreRecords();
								 }
					},
					//조회조건 계좌번호 복호화
					fnDecrypt: function() {	
						var form = popupWin.down('#search');
						var param= form.getValues();
						popupService.incryptDecryptPopup(param, function(provider, response) {
							if(!Ext.isEmpty(provider)){
								form.setValue('TXT_SEARCH', provider);
										
							}
						})
					}		
				});
		}	
		if(!(returnRecord.get("DR_CR") == "2" && returnRecord.get("SPEC_DIVI") == "F2" && UniUtils.indexOf(returnRecord.get("PROOF_KIND"),["13","14","15","16","17"]) > -1 )) {
			popupWin.returnRecord		= returnRecord;
			popupWin.searchTxt 			= searchTxt;
			popupWin.codeColName		= codeColName;
			popupWin.nameColName		= nameColName
			popupWin.companyColName		= companyColName
			popupWin.companyNmColName	= companyNmColName
			popupWin.rateColNme			= rateColNme
			
			popupWin.rdoType 			= rdoType;
			popupWin.center();		
			popupWin.show();
		}
		return popupWin;
	}
	
	/*function openCrediNotWin(record) {
		
		if(record){
			if(!creditNoWin) {
					creditNoWin = Ext.create('widget.uniDetailWindow', {
						title: '신용카드번호 & 현금영수증',
						width: 350,								
						height:140,
						
						layout: {type:'vbox', align:'stretch'},					
						items: [{
								itemId:'search',
								xtype:'uniSearchForm',
								style:{
									'background':'#fff'
								},
								margine:'3 3 3 3',
								items:[
									{
										xtype:'component',
										html:' <div style="line-height:30px;"> * 번호를 입력하십시오.</div>'
									},
									{	
										hideLabel:true,
										height:28,
										labelWidth:60,
										name :'CREDIT_NUM',
										width:300
									}
									
								]
							}
						],
						tbar:  [
							 '->',{
								itemId : 'submitBtn',
								text: '확인',
								handler: function() {
									var creditNum = creditNoWin.down('#search').getValue('CREDIT_NUM');
									if(creditNum && creditNum.length > 0) {
										creditNoWin.rtnRecord.set('CREDIT_NUM', creditNum );
									}
									creditNoWin.hide();
								},
								disabled: false
							},{
								itemId : 'closeBtn',
								text: '닫기',
								handler: function() {
									creditNoWin.hide();
								},
								disabled: false
							}
						],
						listeners : {beforehide: function(me, eOpt) {
										creditNoWin.down('#search').clearForm();
									},
									beforeclose: function( panel, eOpts ) {
										creditNoWin.down('#search').clearForm();
									},
									show: function( panel, eOpts ) {
										var form = creditNoWin.down('#search');
										form.setValue('CREDIT_NUM', creditNoWin.rtnRecord.get('CREDIT_NUM'));
									}
						}		
					});
			}	
			creditNoWin.rtnRecord = record;
			creditNoWin.center();
			creditNoWin.show();
		}
	}*/
	
	function openPrint(record, gridType, pendGridFlag) {
		var hide_Z1 = false;
		var hide_Z0 = true;
		if(gridType == "3" || gridType == "4" ) {
			hide_Z1 = true;
			hide_Z0 = false;
		}
		if(record || pendGridFlag){
			if(!printWin) {
				Unilite.defineModel('AgjPrintModel', {
					fields: [
						{name: 'AC_DATE'		,text: '전표일'		,type: 'uniDate'},
						{name: 'SLIP_NUM'		,text: '번호'			,type: 'string'},
						{name: 'EX_DATE'		,text: 'EX_DATE'	,type: 'uniDate'},
						{name: 'EX_NUM'			,text: 'EX_NUM'		,type: 'string'},
						{name: 'DR_AMT_I'		,text: '차변금액'		,type: 'uniPrice'},
						{name: 'CR_AMT_I'		,text: '대변금액'		,type: 'uniPrice'},
						{name: 'INPUT_PATH'		,text: '입력경로'		,type: 'string' ,comboType:"AU", comboCode:"A011" },
						{name: 'CHARGE_NAME'	,text: '입력자'		,type: 'string'},
						{name: 'INPUT_DATE'		,text: '입력일'		,type: 'uniDate'},
						{name: 'AP_CHARGE_NAME'	,text: '승인자'		,type: 'string'},
						{name: 'AP_DATE'		,text: '승인일'		,type: 'uniDate'} 
					]
				});
				var printStore = Unilite.createStore('printStore',{
					model: 'AgjPrintModel',
					uniOpt : {
						isMaster:	false,			// 상위 버튼 연결 
						editable:	false,			// 수정 모드 사용 
						deletable:	false,			// 삭제 가능 여부 
						useNavi:	false			// prev | newxt 버튼 사용
					},
					autoLoad: false,
					proxy: {
						type: 'direct',
						api: {
							read: 'agj270skrService.selectList'
						}
					},
					loadStoreRecords : function() {
						var form= printWin.down('#search');
						if(form.isValid()) {
							var param= form.getValues();
							param.SLIP_DIVI = csSLIP_TYPE;
							console.log( param );
							this.load({
								params : param,
								callback:function(records, operation, success) {
									var slipPrint = '${slipPrint}', prtReturnYn='${prtReturnYn}';
									var pgmId = 'AGJ270SKR', pgrId = "agj270rkr_L2", printType="L2";
									if(success){
										if(slipPrint == "1") {
											alert("세로 2장 모드 레포트는 개발중입니다.");
											return;
										}else if(slipPrint == "2") {
											if(prtReturnYn =="1") {
												pgrId="agj270rkr_P3";
												printType = "P3";
											}else {
												pgrId="agj270rkr_P4";
												printType = "P4";
											}
										}else {
											if(prtReturnYn =="1") {
												pgrId="agj270rkr_L1";
												printType = "L1";
											}else {
												pgrId="agj270rkr_L2";
												printType = "L2";
											}
										}
										var acDate= new Array(), slipNum= new Array(), exDate= new Array(), exNum= new Array();
								
										Ext.each(records, function(item, idx){
											acDate[idx] 	= (!Ext.isEmpty(item.get('AC_DATE')) && !Ext.isEmpty(item.get('SLIP_NUM')))  ? UniDate.getDateStr(item.get('AC_DATE'))+item.get('SLIP_NUM'): ' ' ;
											
											//exDate[idx] 	= (!Ext.isEmpty(item.get('EX_DATE')))  ?  UniDate.getDateStr(item.get('EX_DATE')): ' ';
											//exNum[idx] 		= (!Ext.isEmpty(item.get('EX_NUM')))   ?  item.get('EX_NUM'): ' ';
										})
										var win = Ext.create('widget.PDFPrintWindow', {
											url: CPATH+'/agj/agj270rkrPrint.do',
											prgID: pgrId, //'agj270rkr',
											extParam: {
												AC_DATE			: acDate,
												//SLIP_NUM		: slipNum,
												SLIP_DIVI  		: csSLIP_TYPE,
												SLIP_NAME   	: csSLIP_TYPE_NAME,
												//EX_DATE			: exDate,
												//EX_NUM			: exNum
												PRINT_TYPE		: printType,
												PGM_ID			: pgmId
											}
										});
										win.center();
										win.show();
										
										printWin.hide();
									}
								}
							});
						}
					}
				});
				printWin= Ext.create('widget.uniDetailWindow', {
					title: '전표출력',
					width: 350,
					height:170,
					layout: {type:'vbox', align:'stretch'},
					items: [{
							itemId:'search',
							xtype:'uniSearchForm',
							style:{
								'background':'#fff'
							},
							margine:'3 3 3 3',
							items:[{
								fieldLabel: '전표일',
								xtype: 'uniDateRangefield',
								startFieldName: 'FR_AC_DATE',
								endFieldName: 'TO_AC_DATE',
								startDate:UniDate.get('today'),// '20130801', //
								endDate: UniDate.get('today'),// '20130808', //
								allowBlank:false
							},{
							 	xtype: 'container',
								defaultType: 'uniNumberfield',
								layout: {type: 'hbox', align:'stretch'},
								width:325,
								margin:'0 0 2 0',
								hidden: hide_Z1,
								items:[{
									fieldLabel:'결의번호',  name: 'FR_EX_NUM', width:194
								},{
									xtype:'component',
									width:10,
									html:'<div style="line-height:19px;font-size:11px;text-align:center;color:#333;">~</div>'
								}, {
									name: 'TO_EX_NUM', width:110
								}] 
							},{
							 	xtype: 'container',
								defaultType: 'uniNumberfield',
								layout: {type: 'hbox', align:'stretch'},
								width:325,
								margin:'0 0 2 0',
								hidden:hide_Z0,
								items:[{
									fieldLabel:'회계번호',  name: 'FR_SLIP_NUM', width:194
								},{
									xtype:'component',
									width:10,
									html:'<div style="line-height:19px;font-size:11px;text-align:center;color:#333;">~</div>'
								}, {
									name: 'TO_SLIP_NUM', width:110
								}] 
							},{
								fieldLabel: '입력경로',
								name: 'INPUT_PATH',		  
								xtype: 'uniCombobox' ,
								comboType: 'AU',
								comboCode: 'A011',
//										store: Ext.data.StoreManager.lookup('comboInputPath'),
								value:'Z1'
							}, {
								fieldLabel: '승인상태',
								xtype: 'uniCombobox',
								name: 'AP_STS',
								comboType: 'AU',
								comboCode:'A014',
								value:'1'
							}, {
								fieldLabel: '전표구분',
								name: 'SLIP_DIVI',
								hidden:true,
								value:csSLIP_TYPE
							}
						]}
					],
					tbar:  [
						 '->',{
							itemId : 'submitBtn',
							text: '출력',
							handler: function() {
								var store = Ext.data.StoreManager.lookup('printStore') ;
								store.loadStoreRecords();
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								printWin.hide();
							},
							disabled: false
						}
					],
					listeners : {
						beforehide: function(me, eOpt) {
							printWin.down('#search').clearForm();
						},
						beforeclose: function( panel, eOpts ) {
							printWin.down('#search').clearForm();
						},
						show: function( panel, eOpts ) {
							var form = printWin.down('#search');
							var grdType = gridType;
							if (record) {
								form.setValue('FR_AC_DATE', printWin.selRecord.get('AC_DATE'));
								form.setValue('TO_AC_DATE', printWin.selRecord.get('AC_DATE'));
								form.setValue('INPUT_PATH', !Ext.isEmpty(panelSearch.getValue('INPUT_PATH')) ? panelSearch.getValue('INPUT_PATH'):csINPUT_PATH);
								if(grdType == "3" || grdType =="4") {
									form.setValue('FR_SLIP_NUM', printWin.selRecord.get('SLIP_NUM'));
									form.setValue('TO_SLIP_NUM', printWin.selRecord.get('SLIP_NUM'));	
								}else {
									form.setValue('FR_EX_NUM', printWin.selRecord.get('SLIP_NUM'));
									form.setValue('TO_EX_NUM', printWin.selRecord.get('SLIP_NUM'));	
								}
								form.setValue('AP_STS', Unilite.nvl(printWin.selRecord.get('AP_STS'),'1'));
							//미결반제 데이터만 있을 경우
							} else {
								form.setValue('FR_AC_DATE', panelSearch.getValue('AC_DATE'));
								form.setValue('TO_AC_DATE', panelSearch.getValue('AC_DATE'));
								form.setValue('INPUT_PATH', !Ext.isEmpty(panelSearch.getValue('INPUT_PATH')) ? panelSearch.getValue('INPUT_PATH'):csINPUT_PATH);
								if(grdType == "3" || grdType =="4") {
									form.setValue('FR_SLIP_NUM', panelSearch.getValue('EX_NUM'));
									form.setValue('TO_SLIP_NUM', panelSearch.getValue('EX_NUM'));	
								}else {
									form.setValue('FR_EX_NUM', panelSearch.getValue('EX_NUM'));
									form.setValue('TO_EX_NUM', panelSearch.getValue('EX_NUM'));	
								}
								form.setValue('AP_STS', Unilite.nvl(printWin.selRecord.get('AP_STS'),'1'));
							}
						}
					}
				});
			}	
			if(Ext.isEmpty(record)) {
				var pendGridRecord = pendGrid.getSelectedRecord();
				printWin.selRecord = pendGridRecord;
			} else {
				printWin.selRecord = record;
			}
			printWin.center();
			printWin.show();
		}
	}

	function openPostIt(grid) {
		var record = grid.getSelectedRecord();
		if(record){
			if(!postitWindow) {
				postitWindow = Ext.create('widget.uniDetailWindow', {
					title: '각주',
					width: 350,
					height:100,
					layout: {type:'vbox', align:'stretch'},
					items: [{
						itemId:'remarkSearch',
						xtype:'uniSearchForm',
						items:[{
							fieldLabel:'각주',
							labelWidth:60,
							name :'POSTIT',
							width:300
						}]
					}],
					tbar:  [
						 '->',{
						itemId : 'submitBtn',
						text: '확인',
						handler: function() {
							var aGrid =grid;
							var record = aGrid.getSelectedRecord();
							var postIt = postitWindow.down('#remarkSearch').getValue('POSTIT');
							if(postIt && postIt.length > 0) {
								record.set('POSTIT', postIt );
								record.set('POSTIT_YN', 'Y' );
								record.set('POSTIT_USER_ID', UserInfo.userID );
							}
							postitWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							postitWindow.hide();
						},
						disabled: false
					}],
					listeners : {beforehide: function(me, eOpt) {
									postitWindow.down('#remarkSearch').clearForm();
								},
								 beforeclose: function( panel, eOpts ) {
									postitWindow.down('#remarkSearch').clearForm();
								},
								 show: function( panel, eOpts ) {
									var aGrid = grid
									var selectedRec = aGrid.getSelectedRecord();
									var form = postitWindow.down('#remarkSearch');
									form.setValue('POSTIT', selectedRec.get('POSTIT'));
									form.setValue('POSTIT_YN', selectedRec.get('POSTIT_YN'));
									form.setValue('POSTIT_USER_ID', selectedRec.get('POSTIT_USER_ID'));
								 }
					}
				});
			}
			postitWindow.center();
			postitWindow.show();
		}
	}
	/**
	 * 외화 금액 입력 팝업
	 * @param {} grid
	 */
	function openForeignCur(record, amtFieldNm) {
		//var record = grid.getSelectedRecord();
		if(record){
			if(!foreignWindow) {
				foreignWindow = Ext.create('widget.uniDetailWindow', {
					title: '외화금액입력',
					width: 300,
					height: 150,
					returnField : amtFieldNm,
					aRecord : record,
					layout: {type:'uniTable', columns:1, tableAttrs:{'width':'100%'}},
					items: [{
						itemId:'foreignCurrency',
						xtype:'uniSearchForm',
						flex: 1,
						style:{'background-color':'#fff'},
						items:[{
							fieldLabel:'화폐단위',
							name :'MONEY_UNIT',
							xtype:'uniCombobox',
							comboType:'AU',
							comboCode:'B004',
							displayField: 'value',
							listeners:{
								change:function(field, newValue, oldValue) {
									if(newValue != oldValue){
										var form = foreignWindow.down('#foreignCurrency');
										if(!form.uniOpt.inLoading){
											if(!Ext.isEmpty(newValue)) {
												foreignWindow.mask();
												accntCommonService.fnGetExchgRate(
													{
														'AC_DATE':	UniDate.getDbDateStr(form.getValue('AC_DATE')),
														'MONEY_UNIT':newValue
													}, 
													function(provider, response){
														foreignWindow.unmask();
														var form = foreignWindow.down('#foreignCurrency');
														if(!Ext.isEmpty(provider['BASE_EXCHG'])) {
															form.setValue('EXCHANGE_RATE',provider['BASE_EXCHG'])
														}
													}
												)
											} else {
												if(!Ext.isEmpty(newValue)) {
													alert('화폐단위를 입력해 주세요')
													return false;
												}
											}
										}
									}
									return true;
								}
							}
						},{
							fieldLabel:'환율',
							xtype:'uniNumberfield',
							name :'EXCHANGE_RATE',
							allowOnlyWhitespace : true,
							decimalPrecision: UniFormat.ER.indexOf('.') > -1 ? UniFormat.ER.length-1 - UniFormat.ER.indexOf('.'):0,
							minValue:0,
							value:1
						},{
							fieldLabel:'외화금액',
							xtype:'uniNumberfield',
							name :'FOR_AMT_I',
							type:'uniFC',
							//decimalPrecision: baseInfo.gsAmtPoint,
							listeners:{
								specialkey:function(field, event) {
									if(event.getKey() == event.ENTER) {
										foreignWindow.onApply();
									}
								}
							}
						},{
							hidden:true,
							fieldLabel:'일자',
							xtype:'uniDatefield',
							name :'AC_DATE'
						}]
					}],
					tbar:  [
						 '->',{
							itemId : 'submitBtn',
							text: '확인',
							handler: function() {
								foreignWindow.onApply();
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								foreignWindow.hide();
							},
							disabled: false
						}
					],
					listeners : {
						beforehide: function(me, eOpt) {
							foreignWindow.down('#foreignCurrency').clearForm();
						},
						 beforeclose: function( panel, eOpts ) {
							foreignWindow.down('#foreignCurrency').clearForm();
						},
						show: function( panel, eOpts ) {
							var selectedRec = foreignWindow.aRecord;
							var form = foreignWindow.down('#foreignCurrency');
							form.uniOpt.inLoading =true;
							form.setValue('AC_DATE', selectedRec.get('AC_DATE'));
							form.setValue('EXCHANGE_RATE', selectedRec.get('EXCHG_RATE_O'));
							form.setValue('MONEY_UNIT', selectedRec.get('MONEY_UNIT'));
							form.setValue('FOR_AMT_I', selectedRec.get('FOR_AMT_I'));
							form.uniOpt.inLoading =false;
						}
					},
					onApply:function() {
						var record = foreignWindow.aRecord;
						var form = foreignWindow.down('#foreignCurrency');
						var mUnit = form.getValue('MONEY_UNIT'), 
							forAmt = form.getValue('FOR_AMT_I'), 
							exRate = Ext.isEmpty(form.getValue('EXCHANGE_RATE')) ? 1:form.getValue('EXCHANGE_RATE') ;
						if(!Ext.isEmpty(mUnit) && !Ext.isEmpty(forAmt) &&  !Ext.isEmpty(exRate)) {
							record.set('MONEY_UNIT',  	mUnit);
							record.set('EXCHG_RATE_O', 	exRate );
							record.set('FOR_AMT_I', 	forAmt );
							var numDigit = 0;
							if(UniFormat.Price.indexOf(".") > -1) {
								numDigit = (UniFormat.Price.length - (UniFormat.Price.indexOf(".")+1));
							}
							var amt = forAmt * exRate;
							amt = UniAccnt.fnAmtWonCalc(amt, baseInfo.gsAmtPoint, numDigit);
							record.set(foreignWindow.returnField, amt);
							record.set("AMT_I", amt);
						}else {
							if(Ext.isEmpty(mUnit)) alert("화폐단위를 입력해 주세요");
							if(Ext.isEmpty(forAmt)) alert("환율을 입력해 주세요"); 
							if(Ext.isEmpty(exRate)) alert("외화금액을 입력해 주세요"); 
						}
						foreignWindow.hide();
					}
				});
			}
			foreignWindow.returnField = amtFieldNm;
			foreignWindow.aRecord = record;
			foreignWindow.center();
			foreignWindow.show();
		}
	}
	var wasSpecDiviFocus  = false;	// selectionChange 시 초기화 시킴.

	function enterNavigation(keyEvent) {
		var position= keyEvent.position,
		view		= position.view;
		navi		= view.getNavigationModel(),
		dataIndex	= position.column.dataIndex;
		var goToForm= false, bSpecDivi= false, goFName ;
		var record	= keyEvent.record;
		var form	= UniAppManager.app.getActiveForm();

		if(keyEvent.keyCode ==13 && view.store.uniOpt.editable && keyEvent.position.isLastColumn() && !keyEvent.position.column.isLocked() && view.ownerGrid.uniOpt.enterKeyCreateRow) {
			if(record) {
				bSpecDivi = UniUtils.indexOf(record.get("SPEC_DIVI"),['F1','F2']) ;
				for(var i =1 ; i <= 6 ; i++) {
					if(!goToForm && "Y" ==record.get('AC_CTL'+i.toString())) {
						goFName = "AC_DATA"+i.toString();
						
						if(form && Ext.isEmpty(record.get(goFName))) {
							var field = form.getField(goFName);
							if(record.get('AC_POPUP'+i.toString()) == 'Y' && !field) {
								goFName = "AC_DATA_NAME"+i.toString();
							}
							goToForm = true;
						}
					}
				}
			}
			if(!goToForm &&  !bSpecDivi ) {
				UniAppManager.app.onNewDataButtonDown();
				return;
			}else if(bSpecDivi  ){
				// SPEC_DIVI == F1, F2 인경우 값이 있더라고 해당 관리항목으로 Focus 이동
				if(!wasSpecDiviFocus) {	
					wasSpecDiviFocus = true;
					goField("AC_DATA1");	
				}else if(!goToForm) {
					UniAppManager.app.onNewDataButtonDown();
					return;
				}
			}else if(goToForm) {
				if(Ext.isEmpty(record.get(goFName))) {
					goField(goFName);
				}else {
					UniAppManager.app.onNewDataButtonDown();
					return;
				}
			}
		}
		if( baseInfo.gsAmtEnter == "Y" && record.get(dataIndex) == 0 && UniUtils.indexOf(dataIndex,['DR_AMT_I', 'CR_AMT_I'])) {
			if((dataIndex == 'DR_AMT_I' && record.get("DR_CR") == "1") || (dataIndex == 'CR_AMT_I' && record.get("DR_CR") == "2" )) {
				return;
			}
		}
		if(Ext.isEmpty(record.get(dataIndex)) && record.phantom  ) {
			var rowIdx = position.rowIdx;
			if(rowIdx > 0) {
				var store = view.getStore();
				var prevRec = store.getAt(rowIdx-1);
				if(prevRec.get('AC_DAY') == record.get('AC_DAY') && prevRec.get('SLIP_NUM') == record.get('SLIP_NUM')) {
					if(dataIndex != 'ACCNT' && dataIndex != 'CUSTOM_CODE' && dataIndex != 'PROOF_KIND' && dataIndex != 'PROOF_KIND_NM') { 
						record.set(dataIndex, prevRec.get(dataIndex));					
						if(dataIndex == 'ACCNT_NAME' && !Ext.isEmpty(prevRec.get("ACCNT")) ) {
							record.set("ACCNT", prevRec.get("ACCNT"));
							var accnt = prevRec.get("ACCNT");
							Ext.getBody().mask();
							accntCommonService.fnGetAccntInfo({'ACCNT_CD':accnt}, function(provider, response){
								Ext.getBody().unmask();
								var rtnRecord = record;
								var detailForm = UniAppManager.app.getActiveForm();
								if(provider){
									UniAppManager.app.loadDataAccntInfo(rtnRecord, detailForm, provider)
								}
							})
							//UniAppManager.app.loadDataAccntInfo(record, form, prevRec.data )
						}
						if(dataIndex == 'CUSTOM_NAME') {
							var form = UniAppManager.app.getActiveForm();
							record.set("CUSTOM_CODE", prevRec.get("CUSTOM_CODE"));
							record.set('CUSTOM_NAME',prevRec.get('CUSTOM_NAME'));
							for(var i=1 ; i <= 6 ; i++) {
								if(record.get("AC_CODE"+i.toString()) == 'A4') {
									record.set('AC_DATA'+i.toString()			,prevRec.get("CUSTOM_CODE"));
									record.set('AC_DATA_NAME'+i.toString()		,prevRec.get("CUSTOM_NAME"));
									form.setValue('AC_DATA'+i.toString()		,prevRec.get("CUSTOM_CODE"));
									form.setValue('AC_DATA_NAME'+i.toString()	,prevRec.get("CUSTOM_NAME"));
								}else if(record.get("AC_CODE"+i.toString()) == 'O2') {
									record.set('AC_DATA'+i.toString()			,prevRec.get('AC_DATA'+i.toString()));
									record.set('AC_DATA_NAME'+i.toString()		,prevRec.get('AC_DATA_NAME'+i.toString()));
									form.setValue('AC_DATA'+i.toString()		,prevRec.get('AC_DATA'+i.toString()));
									form.setValue('AC_DATA_NAME'+i.toString()	,prevRec.get('AC_DATA_NAME'+i.toString()));
								}
							}
							//form.setActiveRecord(record);
						}
						if(dataIndex == 'DR_CR') {
							record.set(dataIndex, prevRec.get(dataIndex));
						}
					}
				}
			}
		}
		var newPosition ;
		if(!keyEvent.shiftKey) {
			newPosition = navi.move('right', keyEvent);
		}else {
			newPosition = navi.move('left', keyEvent);
		}
		if (newPosition) {
			navi.setPosition(newPosition, null, keyEvent);
		}
	}
	function goField(fieldName) {
		var form		= UniAppManager.app.getActiveForm();
		var focusField	= form.getField(fieldName);
		var fEl			= Ext.isEmpty(focusField.el.down('.x-form-cb-input')) ? focusField.el.down('.x-form-field'):focusField.el.down('.x-form-cb-input');
		fEl.focus(10);
	}