<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agj100ukr"  >
	<t:ExtComboStore comboType="BOR120" /><!-- 사업장    -->  
	<t:ExtComboStore comboType="AU" comboCode="A011" />   
	<t:ExtComboStore comboType="AU" comboCode="A005" />        
	<t:ExtComboStore comboType="AU" comboCode="A022" /><!-- 매입증빙유형-->
	<t:ExtComboStore comboType="AU" comboCode="B004" />     
	<t:ExtComboStore comboType="AU" comboCode="A003" />  
	<t:ExtComboStore comboType="AU" comboCode="A022" />  
	<t:ExtComboStore comboType="AU" comboCode="A014" /><!--승인상태-->   
	<t:ExtComboStore comboType="AU" comboCode="B013" />
	<t:ExtComboStore comboType="AU" comboCode="A058" />
	<t:ExtComboStore comboType="AU" comboCode="B004" />
	<t:ExtComboStore comboType="AU" comboCode="A003" />
	<t:ExtComboStore comboType="AU" comboCode="A022" />
	<t:ExtComboStore comboType="AU" comboCode="A149" />
</t:appConfig>
<script type="text/javascript" >
var MANUAL_YN ='N';
var detailWin;
var csINPUT_DIVI	 = "1";	//1:결의전표/2:결의전표(전표번호별)
var csSLIP_TYPE      = "2";	//1:회계전표/2:결의전표
var csINPUT_PATH	 = 'Y1';
function appMain() {

	/**
	 * Model 정의 
	 * @type 
	 */
	Unilite.defineModel('agj100ukrModel1', {
		// pkGen : user, system(default)
	    fields: [ 
	    	 {name: 'AC_DAY'    		,text:'일자'				,type : 'string', allowBlank:false} 
			,{name: 'SLIP_NUM'   		,text:'번호'				,type : 'int', allowBlank:false} 
			,{name: 'SLIP_SEQ'    		,text:'순번'				,type : 'int'} 
			,{name: 'SLIP_DIVI'    		,text:'구분'				,type : 'string', allowBlank:false, defaultValue:'3'} 
			,{name: 'ACCNT'    			,text:'계정코드'			,type : 'string', allowBlank:false} 
			,{name: 'ACCNT_NAME'    	,text:'계정과목명'			,type : 'string'} 
			,{name: 'CUSTOM_CODE'    	,text:'거래처'				,type : 'string'} 
			,{name: 'CUSTOM_NAME'    	,text:'거래처명'			,type : 'string'} 
			,{name: 'AMT_I'    			,text:'금액'				,type : 'uniPrice', allowBlank:false} 
			,{name: 'REMARK'    		,text:'적요'				,type : 'string'} 
			,{name: 'PROOF_KIND_NM'    	,text:'증빙유형'			,type : 'string'} 
			,{name: 'DEPT_NAME'    		,text:'귀속부서'			,type : 'string', allowBlank:false, defaultValue:UserInfo.deptName} 
			,{name: 'DIV_CODE'    		,text:'사업장'				,type : 'string', comboType:'BOR120', defaultValue:UserInfo.divCode}
			//,{name: 'OLD_AC_DATE'    	,text:''	,type : 'string'} 
			//,{name: 'OLD_SLIP_NUM'    	,text:''	,type : 'int'} 
			//,{name: 'OLD_SLIP_SEQ'    	,text:''	,type : 'int'}
			,{name: 'AC_DATE'    		,text:'회계전표일자'		,type : 'string'} 
			,{name: 'DR_CR'    			,text:'차대구분'			,type : 'string', defaultValue:'1'} 
			,{name: 'P_ACCNT'    		,text:'상대계정코드'		,type : 'string'} 
			,{name: 'DEPT_CODE'    		,text:'귀속부서코드'		,type : 'string', defaultValue:UserInfo.deptCode} 
			,{name: 'PROOF_KIND'    	,text:'증빙종류'			,type : 'string'} 
			,{name: 'CREDIT_CODE'    	,text:'신용카드사코드'		,type : 'string'} 
			,{name: 'REASON_CODE'    	,text:'불공제사유코드'		,type : 'string'} 
			,{name: 'CREDIT_NUM'    	,text:'신용카드,현금영수증'	,type : 'string'} 
			,{name: 'MONEY_UNIT'    	,text:'화폐단위'			,type : 'string'} 
			,{name: 'EXCHG_RATE_O'    	,text:'환율'				,type : 'uniER'} 
			,{name: 'FOR_AMT_I'    		,text:'외화금액'			,type : 'uniPrice'}
			,{name: 'IN_DIV_CODE'    	,text:'결의사업장코드'		,type : 'string', defaultValue:UserInfo.divCode} 
			,{name: 'IN_DEPT_CODE'    	,text:'결의부서코드'		,type : 'string', defaultValue:UserInfo.deptCode} 
			,{name: 'IN_DEPT_NAME'    	,text:'결의부서'			,type : 'string', defaultValue:UserInfo.deptName}
			,{name: 'BILL_DIV_CODE'    	,text:'신고사업장코드'		,type : 'string'}
			,{name: 'AC_CODE1'    		,text:'관리항목코드1'		,type : 'string'} 
			,{name: 'AC_CODE2'    		,text:'관리항목코드2'		,type : 'string'} 
			,{name: 'AC_CODE3'    		,text:'관리항목코드3'		,type : 'string'} 
			,{name: 'AC_CODE4'    		,text:'관리항목코드4'		,type : 'string'} 
			,{name: 'AC_CODE5'    		,text:'관리항목코드5'		,type : 'string'} 
			,{name: 'AC_CODE6'    		,text:'관리항목코드6'		,type : 'string'}
			,{name: 'AC_NAME1'    		,text:'관리항목명1'			,type : 'string'} 
			,{name: 'AC_NAME2'    		,text:'관리항목명2'			,type : 'string'} 
			,{name: 'AC_NAME3'    		,text:'관리항목명3'			,type : 'string'} 
			,{name: 'AC_NAME4'    		,text:'관리항목명4'			,type : 'string'} 
			,{name: 'AC_NAME5'    		,text:'관리항목명5'			,type : 'string'} 
			,{name: 'AC_NAME6'    		,text:'관리항목명6'			,type : 'string'}
			,{name: 'AC_DATA1'    		,text:'관리항목데이터1'		,type : 'string'} 
			,{name: 'AC_DATA2'    		,text:'관리항목데이터2'		,type : 'string'} 
			,{name: 'AC_DATA3'    		,text:'관리항목데이터3'		,type : 'string'} 
			,{name: 'AC_DATA4'    		,text:'관리항목데이터4'		,type : 'string'} 
			,{name: 'AC_DATA5'    		,text:'관리항목데이터5'		,type : 'string'} 
			,{name: 'AC_DATA6'    		,text:'관리항목데이터6'		,type : 'string'}
			,{name: 'AC_DATA_NAME1'    	,text:'관리항목데이터명1'	,type : 'string'} 
			,{name: 'AC_DATA_NAME2'    	,text:'관리항목데이터명2'	,type : 'string'} 
			,{name: 'AC_DATA_NAME3'    	,text:'관리항목데이터명3'	,type : 'string'} 
			,{name: 'AC_DATA_NAME4'    	,text:'관리항목데이터명4'	,type : 'string'} 
			,{name: 'AC_DATA_NAME5'    	,text:'관리항목데이터명5'	,type : 'string'} 
			,{name: 'AC_DATA_NAME6'    	,text:'관리항목데이터명6'	,type : 'string'}
			,{name: 'BOOK_CODE1'    	,text:'계정잔액코드1'		,type : 'string'} 
			,{name: 'BOOK_CODE2'    	,text:'계정잔액코드2'		,type : 'string'} 
			,{name: 'BOOK_DATA1'       	,text:'계정잔액데이터1'		,type : 'string'} 
			,{name: 'BOOK_DATA2'    	,text:'계정잔액데이터2'		,type : 'string'} 
			,{name: 'BOOK_DATA_NAME1'	,text:'계정잔액데이터명1'	,type : 'string'} 
			,{name: 'BOOK_DATA_NAME2'   ,text:'계정잔액데이터명2'	,type : 'string'} 
			,{name: 'ACCNT_SPEC'   		,text:'계정특성'			,type : 'string'} 
			,{name: 'SPEC_DIVI'    		,text:'자산부채특성'		,type : 'string'} 
			,{name: 'PROFIT_DIVI'    	,text:'손익특성'			,type : 'string'} 
			,{name: 'JAN_DIVI'    		,text:'잔액변(차대)'		,type : 'string'} 
			,{name: 'PEND_YN'    		,text:'미결관리여부'		,type : 'string'} 
			,{name: 'PEND_CODE'    		,text:'미결항목'			,type : 'string'} 
			,{name: 'PEND_DATA_CODE'  	,text:'미결항목데이터코드'	,type : 'string'} 
			,{name: 'BUDG_YN'    		,text:'예산사용여부'		,type : 'string'} 
			,{name: 'BUDGCTL_YN'    	,text:'예산통제여부'		,type : 'string'} 
			,{name: 'FOR_YN'     		,text:'외화구분'			,type : 'string'} 
			,{name: 'POSTIT_YN'    		,text:'주석체크여부'		,type : 'string'} 
			,{name: 'POSTIT'     		,text:'주석내용'			,type : 'string'} 
			,{name: 'POSTIT_USER_ID'  	,text:'주석체크자'			,type : 'string'} 
			,{name: 'INPUT_PATH'    	,text:'입력경로'			,type : 'string', defaultValue: csINPUT_PATH} 
			,{name: 'INPUT_DIVI'    	,text:'전표입력경로'		,type : 'string', defaultValue: csINPUT_DIVI} 
			,{name: 'AUTO_SLIP_NUM'   	,text:'자동기표번호'		,type : 'string'} 
			,{name: 'CLOSE_FG'     		,text:'마감여부'			,type : 'string'} 
			,{name: 'INPUT_DATE'    	,text:'입력일자'			,type : 'string'} 
			,{name: 'INPUT_USER_ID'   	,text:'입력자ID'			,type : 'string'} 
			,{name: 'CHARGE_CODE'    	,text:'담당자코드'			,type : 'string'} 
			,{name: 'AP_STS'     		,text:'승인상태'			,type : 'string', defaultValue:'1'} 
			,{name: 'AP_DATE'     		,text:'승인처리일'			,type : 'string'} 
			,{name: 'AP_USER_ID'    	,text:'승인자ID'			,type : 'string'} 
			,{name: 'EX_DATE'     		,text:'회계전표일자'		,type : 'string'} 
			,{name: 'EX_NUM'    		,text:'회계전표번호'		,type : 'int'} 
			,{name: 'EX_SEQ'    		,text:'회계전표순번'		,type : 'string'} 
			
			,{name: 'AC_CTL1'   		,text:'관리항목필수1'		,type : 'string'} 
			,{name: 'AC_CTL2'   		,text:'관리항목필수2'		,type : 'string'} 
			,{name: 'AC_CTL3'   		,text:'관리항목필수3'		,type : 'string'} 
			,{name: 'AC_CTL4'   		,text:'관리항목필수4'		,type : 'string'} 
			,{name: 'AC_CTL5'    		,text:'관리항목필수5'		,type : 'string'} 
			,{name: 'AC_CTL6'    		,text:'관리항목필수6'		,type : 'string'} 
			
			,{name: 'AC_TYPE1'   		,text:'관리항목1유형'		,type : 'string'} 
			,{name: 'AC_TYPE2'   		,text:'관리항목2유형'		,type : 'string'} 
			,{name: 'AC_TYPE3'   		,text:'관리항목3유형'		,type : 'string'} 
			,{name: 'AC_TYPE4'   		,text:'관리항목4유형'		,type : 'string'} 
			,{name: 'AC_TYPE5'   		,text:'관리항목5유형'		,type : 'string'} 
			,{name: 'AC_TYPE6'   		,text:'관리항목6유형'		,type : 'string'} 
			
			,{name: 'AC_LEN1'    		,text:'관리항목1길이'		,type : 'string'} 
			,{name: 'AC_LEN2'   		,text:'관리항목2길이'		,type : 'string'} 
			,{name: 'AC_LEN3'   		,text:'관리항목3길이'		,type : 'string'} 
			,{name: 'AC_LEN4'   		,text:'관리항목4길이'		,type : 'string'} 
			,{name: 'AC_LEN5'   		,text:'관리항목5길이'		,type : 'string'} 
			,{name: 'AC_LEN6'   		,text:'관리항목6길이'		,type : 'string'} 
			
			,{name: 'AC_POPUP1' 		,text:'관리항목1팝업여부'	,type : 'string'} 
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
			,{name: 'COMP_CODE'    		,text:'법인코드'			,type : 'string'} 
			,{name: 'DRAFT_YN'    		,text:'기안여부(E-Ware)'	,type : 'string'} 
			,{name: 'AGREE_YN'    		,text:'결재완료(E-Ware)'	,type : 'string'} 
		]
	});
	
	/**
	 * 일반전표 Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('agj100ukrMasterStore1',{
			model: 'agj100ukrModel1',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : true			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	   read : 'agj100ukrService.selectList'
//                	,update : 'agj100ukrService.updateMulti'
//					,create : 'agj100ukrService.insertMulti'
//					,destroy:'agj100ukrService.deleteMulti'
//					,syncAll:'agj100ukrService.syncAll'
                }
            }  // proxy
            
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			,loadStoreRecords : function()	{
				if(Ext.getCmp('searchForm').isValid())	{
					var param= Ext.getCmp('searchForm').getValues();			
					console.log( param );
					panelSearch.getField('AC_DATE_FR').setReadOnly(true);
					panelSearch.getField('AC_DATE_TO').setReadOnly(true);
					panelSearch.getField('INPUT_PATH').setReadOnly(true);
					
					panelResult.getField('AC_DATE_FR').setReadOnly(true);
					panelResult.getField('AC_DATE_TO').setReadOnly(true);
					panelResult.getField('INPUT_PATH').setReadOnly(true);
					this.load({
						params : param
					});
				}
				
			    
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			,saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll(config);
				}else {
					alert(Msg.sMB083);
				}
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
	    	items:[
	    		{	    
					fieldLabel: '전표일',
					xtype: 'uniDateRangefield',
		            startFieldName: 'AC_DATE_FR',
		            endFieldName: 'AC_DATE_TO',
		            startDate: UniDate.get('today'), 
                    endDate: UniDate.get('today'), 
				 	allowBlank:false,                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('AC_DATE_FR', newValue);						
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('AC_DATE_TO', newValue);				    		
				    	}
				    }
				},{
				    fieldLabel: '입력경로',
					name: 'INPUT_PATH',          
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'A011',
					value:'Z1',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('INPUT_PATH', newValue);
						}
					}
				},{
					fieldLabel: '사업장',
					name: 'DIV_CODE',       
					xtype: 'uniCombobox' ,
					comboType: 'BOR120',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
			    },{
			    	xtype:'container',
			    	defaultType:'uniTextfield',
			    	layout:{type:'hbox', align:'stretch'},
			    	items:[
			    		{
			    	  	 	fieldLabel:'결의부서',
						 	name : 'DEPT_CODE',
						 	readOnly:true,
							value:UserInfo.deptCode,
							width:150
					    },{
							fieldLabel: '결의부서명',
						    textFieldName:'DEPT_NAME',
						 	value: UserInfo.deptName,
						 	readOnly: true,
						 	hideLabel:true
						}
					]
			    },{
	    	  	 	fieldLabel: '입력자ID',
	    	  	 	name:'CHARGE_CODE',
	    	  	 	value: UserInfo.userID,
	    	  	 	hidden:true,
				 	allowBlank:false
				},{
					fieldLabel: '입력자',
				    textFieldName:'CHARGE_NAME',
				 	value: UserInfo.userName,
				 	readOnly: true
				},{
					fieldLabel: '승인상태',
					name: 'AP_STS' ,          
					xtype: 'uniCombobox' ,
					comboType: 'AU',
					comboCode: 'A014' ,
					allowBlank: false,
					value :'2',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AP_STS', newValue);
						}
					}
				},
				Unilite.popup('MANAGE',{
				itemId :'MANAGE',
				fieldLabel: '관리항목',
				allowBlank:false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('MANAGE_CODE', panelSearch.getValue('MANAGE_CODE'));
							panelResult.setValue('MANAGE_NAME', panelSearch.getValue('MANAGE_NAME'));
							/**
							 * 관리항목 팝업을 작동했을때의 동적 필드 생성(항상 FR과 TO필드 2개를 생성 해준다..) 
							 * 생성된 필드가 팝업일시 필드name은 아래와 같음
							 * 				FR 필드								TO 필드
							 *  valueFieldName    textFieldName	 ~	 valueFieldName	  textFieldName
							 * DYNAMIC_CODE_FR, DYNAMIC_NAME_FR  ~  DYNAMIC_CODE_TO, DYNAMIC_NAME_TO
							 * --------------------------------------------------------------------------
							 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음
							 * 		FR 필드				 ~				TO 필드
							 * 	DYNAMIC_CODE_FR			 ~			DYNAMIC_CODE_TO
							 * */
							var param = {AC_CD : panelSearch.getValue('MANAGE_CODE')};
							accntCommonService.fnGetAcCode(param, function(provider, response)	{
								var dataMap = provider;
								UniAccnt.changeFields(panelSearch, dataMap, panelResult);
								UniAccnt.changeFields(panelResult, dataMap, panelSearch);
							});
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('MANAGE_CODE', '');
						panelResult.setValue('MANAGE_NAME', '');
						/**
						 * onClear시 removeField..
						 */
						UniAccnt.removeField(panelSearch, panelResult);
					},
					applyextparam: function(popup){							
						
					}
				}
			}),Unilite.popup('ACCNT',{
		    	fieldLabel: '계정과목',
				allowBlank:false,	    			
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ACCNT_CODE', panelSearch.getValue('ACCNT_CODE'));
							panelResult.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));
							/**
							 * 계정과목 동적 팝업
							 * 생성된 필드가 팝업일시 필드name은 아래와 같음		
							 * 			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용				
							 *  valueFieldName    textFieldName 		valueFieldName     textFieldName		 	valueFieldName    textFieldName
							 *    PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	   BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
							 * ---------------------------------------------------------------------------------------------------------------------------
							 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
							 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
							 *    PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)		
							 * */
							var param = {ACCNT_CD : panelSearch.getValue('ACCNT_CODE')};
							accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
								var dataMap = provider;
								var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용
								UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);								
								UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
							});
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ACCNT_CODE', '');
						panelResult.setValue('ACCNT_NAME', '');
						/**
						 * onClear시 removeField..
						 */
						UniAccnt.removeField(panelSearch, panelResult);
					},
					applyextparam: function(popup){
						
					}
				}
		    }),{
				xtype: 'container',
				itemId: 'formFieldArea1',	
				layout: {
					type: 'table', 
					columns:1,
					itemCls:'table_td_in_uniTable',
					tdAttrs: {
						'width': 350
					}
				}/*,items:[]*/
			},{
				xtype: 'container',
				itemId: 'formFieldArea2',
				layout: {
					type: 'table', 
					columns:1,
					itemCls:'table_td_in_uniTable',
					tdAttrs: {
						width: 350
					}
				}/*,items:[]*/
			}]
		}]
	});	//end panelSearch    
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
    	items: [{	    
			fieldLabel: '전표일',
			xtype: 'uniDateRangefield',
            startFieldName: 'AC_DATE_FR',
            endFieldName: 'AC_DATE_TO',
            startDate: UniDate.get('today'), 
            endDate: UniDate.get('today'), 
            width: 350,
		 	allowBlank:false,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('AC_DATE_FR', newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('AC_DATE_TO', newValue);				    		
		    	}
		    }
		},{
		    fieldLabel: '입력경로',
			name: 'INPUT_PATH',          
			xtype: 'uniCombobox' ,
			comboType: 'AU',
			comboCode: 'A011',
			value:'Z1',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('INPUT_PATH', newValue);
				}
			}
		},{
			fieldLabel: '사업장',
			name: 'DIV_CODE',       
			xtype: 'uniCombobox' ,
			comboType: 'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
	    },{
	    	xtype:'container',
	    	defaultType:'uniTextfield',
	    	layout:{type:'hbox', align:'stretch'},
	    	items:[
	    		{
	    	  	 	fieldLabel:'결의부서',
				 	name : 'DEPT_CODE',
				 	readOnly:true,
					value:UserInfo.deptCode,
					width:150
			    },{
					fieldLabel: '결의부서명',
				    textFieldName:'DEPT_NAME',
				 	value: UserInfo.deptName,
				 	readOnly: true,
				 	hideLabel:true
				}
			]
	    },{
	  	 	fieldLabel: '입력자ID',
	  	 	name:'CHARGE_CODE',
	  	 	value: UserInfo.userID,
	  	 	hidden:true,
		 	allowBlank:false
		},{
			fieldLabel: '입력자',
		    textFieldName:'CHARGE_NAME',
		 	value: UserInfo.userName,
		 	readOnly: true
		},{
			fieldLabel: '승인상태',
			name: 'AP_STS' ,          
			xtype: 'uniCombobox' ,
			comboType: 'AU',
			comboCode: 'A014' ,
			allowBlank: false,
			value :'2',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('AP_STS', newValue);
				}
			}
		},
		Unilite.popup('MANAGE',{
		itemId :'MANAGE',
		fieldLabel: '관리항목',
		allowBlank:false,
		listeners: {
			onSelected: {
				fn: function(records, type) {
					panelSearch.setValue('MANAGE_CODE', panelResult.getValue('MANAGE_CODE'));
					panelSearch.setValue('MANAGE_NAME', panelResult.getValue('MANAGE_NAME'));
					/**
					 * 관리항목 팝업을 작동했을때의 동적 필드 생성(항상 FR과 TO필드 2개를 생성 해준다..) 
					 * 생성된 필드가 팝업일시 필드name은 아래와 같음
					 * 				FR 필드								TO 필드
					 *  valueFieldName    textFieldName	 ~	 valueFieldName	  textFieldName
					 * DYNAMIC_CODE_FR, DYNAMIC_NAME_FR  ~  DYNAMIC_CODE_TO, DYNAMIC_NAME_TO
					 * --------------------------------------------------------------------------
					 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음
					 * 		FR 필드				 ~				TO 필드
					 * 	DYNAMIC_CODE_FR			 ~			DYNAMIC_CODE_TO
					 * */
					var param = {AC_CD : panelResult.getValue('MANAGE_CODE')};
					accntCommonService.fnGetAcCode(param, function(provider, response)	{
						var dataMap = provider;
						UniAccnt.changeFields(panelResult, dataMap, panelSearch);
						UniAccnt.changeFields(panelSearch, dataMap, panelResult);
					});
				},
				scope: this
			},
			onClear: function(type)	{
				panelSearch.setValue('MANAGE_CODE', '');
				panelSearch.setValue('MANAGE_NAME', '');
				/**
				 * onClear시 removeField..
				 */
				UniAccnt.removeField(panelSearch, panelResult);
			},
			applyextparam: function(popup){							
				
			}
		}
	}),Unilite.popup('ACCNT',{
    	fieldLabel: '계정과목',
		allowBlank:false,
		listeners: {
			onSelected: {
				fn: function(records, type) {
					panelSearch.setValue('ACCNT_CODE', panelResult.getValue('ACCNT_CODE'));
					panelSearch.setValue('ACCNT_NAME', panelResult.getValue('ACCNT_NAME'));
					/**
					 * 계정과목 동적 팝업
					 * 생성된 필드가 팝업일시 필드name은 아래와 같음		
					 * 			opt: '1' 미결항목용							opt: '2' 계정잔액1,2용					opt: '3' 관리항목 1~6용				
					 *  valueFieldName    textFieldName 		valueFieldName     textFieldName		 	valueFieldName    textFieldName
					 *    PEND_CODE			PEND_NAME			 BOOK_CODE1(~2)	   BOOK_NAME1(~2)			 AC_DATA1(~6)	 AC_DATA_NAME1(~6)
					 * -------------------------------------------------------------------------------------------------------------------------
					 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음	
					 * opt: '1' 미결항목용			opt: '2' 계정잔액1,2용			opt: '3' 관리항목 1~6용							 
					 *    PEND_CODE					BOOK_CODE1(~2)				AC_DATA1(~6)		
					 * */
					var param = {ACCNT_CD : panelResult.getValue('ACCNT_CODE')};
					accntCommonService.fnGetAccntInfo(param, function(provider, response)	{
						var dataMap = provider;
						var opt = '2'	//opt: '1' 미결항목용		opt: '2' 계정잔액1,2용		opt: '3' 관리항목 1~6용						
						UniAccnt.addMadeFields(panelResult, dataMap, panelSearch, opt);
						UniAccnt.addMadeFields(panelSearch, dataMap, panelResult, opt);
					});
				},
				scope: this
			},
			onClear: function(type)	{
				panelSearch.setValue('ACCNT_CODE', '');
				panelSearch.setValue('ACCNT_NAME', '');
				/**
				 * onClear시 removeField..
				 */
				UniAccnt.removeField(panelSearch, panelResult);
			},
			applyextparam: function(popup){							
				
			}
		}
    }),{
		xtype: 'container',
		colspan: 3,
		itemId: 'formFieldArea1',		
		layout: {
			type: 'uniTable', 
			columns:1,
			tdAttrs: {
				width: 350
			}
		}/*,items:[]*/
	},{
    	xtype: 'component'
    },{
    	xtype: 'component'
    },{
		xtype: 'container',
		itemId: 'formFieldArea2',		
		layout: {
			type: 'uniTable', 
			columns:1,
			tdAttrs: {
				width: 350
			}
		}/*,items:[]*/
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

    /**
     * 일발전표 Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid1 = Unilite.createGrid('agj100ukrGrid1', {
        flex: 0.65,
		uniOpt:{
        	expandLastColumn: true,
            useMultipleSorting: false            
        },
        border:true,
    	store: directMasterStore1,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		columns:[
			 { dataIndex: 'AC_DAY'			,width: 60 } 
			,{ dataIndex: 'SLIP_NUM'		,width: 60 } 
			,{ dataIndex: 'SLIP_SEQ'		,width: 60 } 
			,{ dataIndex: 'SLIP_DIVI'		,width: 100 } 
			,{ dataIndex: 'ACCNT'			,width: 100 } 
			,{ dataIndex: 'ACCNT_NAME'		,width: 120 } 
			,{ dataIndex: 'CUSTOM_CODE'		,width: 80,
			 	'editor' : Unilite.popup('CUST_G',{	            
					textFieldName:'CUSTOM_CODE',
					DBtextFieldName:'CUSTOM_CODE',
					listeners: {	
		                'onSelected':  function(records, type  ){
		                    	var grdRecord = masterGrid1.uniOpt.currentRecord;
		                    	grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                    	grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
		                },
		                'onClear':  function( type  ){
		                    	var grdRecord = masterGrid1.uniOpt.currentRecord;
		                    	grdRecord.set('CUSTOM_NAME','');
		                    	grdRecord.set('CUSTOM_CODE','');
		                }
	            	} //listeners
				}) 		
			 } 
			,{ dataIndex: 'CUSTOM_NAME'		,width: 180 ,
				'editor' : Unilite.popup('CUST_G',{	            
					textFieldName:'CUSTOM_NAME',
					listeners: {	
		                'onSelected':  function(records, type  ){
		                    	var grdRecord = masterGrid1.uniOpt.currentRecord;
		                    	grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                    	grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
		                },
		                'onClear':  function( type  ){
		                    	var grdRecord = masterGrid1.uniOpt.currentRecord;
		                    	grdRecord.set('CUSTOM_NAME','');
		                    	grdRecord.set('CUSTOM_CODE','');
		                }
	            	} //listeners
				}) 		
			 } 
			,{ dataIndex: 'AMT_I'			,width: 100 } 
			,{ dataIndex: 'REMARK'			,width: 333 } 
			,{ dataIndex: 'PROOF_KIND_NM'	,width: 110 } 
			,{ dataIndex: 'DEPT_NAME'		,width: 100 } 
			,{ dataIndex: 'DIV_CODE'		,width: 80 } 
			/*,{ dataIndex: 'AC_CODE1'    		,width: 100} 
			,{ dataIndex: 'AC_DATA1'    		,width: 100} 
			,{ dataIndex: 'AC_DATA_NAME1'    	,width: 100} 
			,{ dataIndex: 'AC_CODE2'    		,width: 100} 
			,{ dataIndex: 'AC_DATA2'    		,width: 100} 
			,{ dataIndex: 'AC_DATA_NAME2'    	,width: 100} 
			,{ dataIndex: 'AC_CODE3'    		,width: 100} 
			,{ dataIndex: 'AC_DATA3'    		,width: 100} 
			,{ dataIndex: 'AC_DATA_NAME3'    	,width: 100} */
          ] ,
    	listeners:{
    		selectionChange: function( gird, selected, eOpts )	{
    			var fName, acCode, acName, acType, acPopup, acLen, acCtl, acFormat;
    			
    			if(selected.length == 1)	{
    				var dataMap = selected[0].data;
    				/**
					 * masterGrid의 ROW를 select할때마다 동적 필드 생성 최대 6개까지 생성
					 * 생성된 필드가 팝업일시 필드name은 아래와 같음				
					 *  valueFieldName    textFieldName
					 *    AC_DATA1(~6)	 AC_DATA_NAME1(~6)			
					 * --------------------------------------------------------------------------
					 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음							 
					 *    AC_DATA1(~6)		
					 * */
    				UniAccnt.addMadeFields(detailForm1, dataMap, detailForm1);
    				detailForm1.setActiveRecord(selected[0]||null);
    				slipStore1.loadStoreRecords(this.getStore(), dataMap['AC_DAY'], dataMap['SLIP_NUM']);
    				slipStore2.loadStoreRecords(this.getStore(), dataMap['AC_DAY'], dataMap['SLIP_NUM']);
    			}    			
    		}
    	}
    });
    
    var detailForm1 = Unilite.createForm('agj100ukrDetailForm1',  {		
        itemId: 'agj100ukrDetailForm',
		masterGrid: masterGrid1,
		//flex: 0.25
		height: 85,
		disabled: false,
		border: true,
		padding: 0,
//		flex: 1,
		layout : 'hbox',
		defaults:{
			labelWidth: 100
		},
		items:[{
			xtype: 'container',
			itemId: 'formFieldArea1',
			layout: {
				type: 'uniTable', 
				columns:2
			},
			defaults:{
				width:325
			}
		}]	   
	});
	
	
	/**
     * 매입매출전표  Store
     */
    var activeGrid = 'agj100ukrSalesGrid'
	var directMasterStore2 = Unilite.createStore('agj100ukrMasterStore2',{
			model: 'agj100ukrModel1',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : true			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	   read : 'agj100ukrService.selectSalesList'
//                	,update : 'agj100ukrService.updateMulti'
//					,create : 'agj100ukrService.insertMulti'
//					,destroy:'agj100ukrService.deleteMulti'
//					,syncAll:'agj100ukrService.syncAll'
                }
            }  // proxy
            
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			,saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll(config);
				}else {
					alert(Msg.sMB083);
				}
			}
            
		});
		
	/**
     * 매입매출전표  Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid2 = Unilite.createGrid('agj100ukrGrid2', {
        flex: 0.65,
        itemId: 'agj100ukrGrid2',
		uniOpt:{
        	expandLastColumn: true,
            useMultipleSorting: false            
        },
        border:true,
    	store: directMasterStore2,
		columns:[
			 { dataIndex: 'AC_DAY'			,width: 50 } 
			,{ dataIndex: 'SLIP_NUM'		,width: 50 } 
			,{ dataIndex: 'SLIP_SEQ'		,width: 50 } 
			,{ dataIndex: 'SLIP_DIVI'		,width: 100 } 
			,{ dataIndex: 'ACCNT'			,width: 100 } 
			,{ dataIndex: 'ACCNT_NAME'		,width: 110 } 
			,{ dataIndex: 'CUSTOM_CODE'		,width: 80,
			 	'editor' : Unilite.popup('CUST_G',{	            
					textFieldName:'CUSTOM_CODE',
					DBtextFieldName:'CUSTOM_CODE',
					listeners: {	
		                'onSelected':  function(records, type  ){
		                    	var grdRecord = masterGrid1.uniOpt.currentRecord;
		                    	grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                    	grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
		                },
		                'onClear':  function( type  ){
		                    	var grdRecord = masterGrid1.uniOpt.currentRecord;
		                    	grdRecord.set('CUSTOM_NAME','');
		                    	grdRecord.set('CUSTOM_CODE','');
		                }
	            	} //listeners
				}) 		
			 } 
			,{ dataIndex: 'CUSTOM_NAME'		,width: 120 ,
				'editor' : Unilite.popup('CUST_G',{	            
					textFieldName:'CUSTOM_NAME',
					listeners: {	
		                'onSelected':  function(records, type  ){
		                    	var grdRecord = masterGrid1.uniOpt.currentRecord;
		                    	grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
		                    	grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
		                },
		                'onClear':  function( type  ){
		                    	var grdRecord = masterGrid1.uniOpt.currentRecord;
		                    	grdRecord.set('CUSTOM_NAME','');
		                    	grdRecord.set('CUSTOM_CODE','');
		                }
	            	} //listeners
				}) 		
			 } 
			,{ dataIndex: 'AMT_I'			,width: 100 } 
			,{ dataIndex: 'REMARK'			,width: 150 } 
			,{ dataIndex: 'PROOF_KIND_NM'	,width: 110 } 
			,{ dataIndex: 'DEPT_NAME'		,width: 100 } 
			,{ dataIndex: 'DIV_CODE'		,width: 80 } 
			/*,{ dataIndex: 'AC_CODE1'    		,width: 100} 
			,{ dataIndex: 'AC_DATA1'    		,width: 100} 
			,{ dataIndex: 'AC_DATA_NAME1'    	,width: 100} 
			,{ dataIndex: 'AC_CODE2'    		,width: 100} 
			,{ dataIndex: 'AC_DATA2'    		,width: 100} 
			,{ dataIndex: 'AC_DATA_NAME2'    	,width: 100} 
			,{ dataIndex: 'AC_CODE3'    		,width: 100} 
			,{ dataIndex: 'AC_DATA3'    		,width: 100} 
			,{ dataIndex: 'AC_DATA_NAME3'    	,width: 100} */
          ] ,
    	listeners:{
    		selectionChange: function( gird, selected, eOpts )	{
    			var fName, acCode, acName, acType, acPopup, acLen, acCtl, acFormat;
    			
    			if(selected.length == 1)	{
    				var dataMap = selected[0].data;
    				/**
					 * masterGrid의 ROW를 select할때마다 동적 필드 생성 최대 6개까지 생성
					 * 생성된 필드가 팝업일시 필드name은 아래와 같음				
					 *  valueFieldName    textFieldName
					 *    AC_DATA1(~6)	 AC_DATA_NAME1(~6)			
					 * --------------------------------------------------------------------------
					 * 생성된 필드가 uniTextfield, uniNumberfield, uniDatefield일시 필드 name은 아래와 같음							 
					 *    AC_DATA1(~6)		
					 * */
    				UniAccnt.addMadeFields(saleDetailForm, dataMap, saleDetailForm)
    				saleDetailForm.setActiveRecord(selected[0]||null);
    			}
    			
    		},
    		render: function(grid, eOpts){
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	activeGrid = grid.getItemId();
			    });
			 }
    	}
    });
		
   /**
    * 매출/매입 전표 Detail 정보 모델
    */
 
    Unilite.defineModel('agj100ukrSaleModel', {
		// pkGen : user, system(default)
	    fields: [ 
	    	 	 {name: 'AC_DAY'    		,text:'일자'			,type : 'string', allowBlank:false} 
				,{name: 'PUB_DATE'    		,text:'계산서일'		,type : 'uniDate', allowBlank:false} 
				,{name: 'SALE_DIVI'    		,text:'매입/매출'		,type : 'string', allowBlank:false ,comboType: 'AU',	comboCode: 'A003'} 
				,{name: 'BUSI_TYPE_NM'    	,text:'거래유형'		,type : 'string', allowBlank:false} 
				,{name: 'CUSTOM_CODE'    	,text:'거래처'			,type : 'string', allowBlank:false} 
				,{name: 'CUSTOM_NAME'    	,text:'거래처명'		,type : 'string'} 
				,{name: 'PROOF_KIND_NM'    	,text:'증빙유형명'		,type : 'string', allowBlank:false} 
				,{name: 'PROOF_KIND'    	,text:'증빙유형코드'	,type : 'string', allowBlank:false} 
				,{name: 'SUPPLY_AMT_I'    	,text:'공급가액'		,type : 'uniPrice', allowBlank:false} 
				,{name: 'TAX_AMT_I'    		,text:'세액'			,type : 'uniPrice', allowBlank:false} 
				,{name: 'REMARK'    		,text:'적요'			,type : 'string'} 
				,{name: 'DEPT_NAME'    		,text:'귀속부서'		,type : 'string', allowBlank:false, defaultValue: UserInfo.deptName} 
				,{name: 'DIV_CODE'    		,text:'사업장'			,type : 'string', allowBlank:false, comboType:'BOR120', defaultValue: UserInfo.divCode} 
//				,{name: 'OLD_AC_DATE'    	,text:'OLD_AC_DATE'		,type : 'string'} 
//				,{name: 'OLD_SLIP_NUM'    	,text:''				,type : 'int'} 
//				,{name: 'OLD_PUB_DATE'   	,text:''				,type : 'string'} 
//				,{name: 'OLD_PUB_NUM'    	,text:''				,type : 'int'} 
				,{name: 'AC_DATE'    		,text:'회계전표일자'	,type : 'uniDate', allowBlank:false} 
				,{name: 'SLIP_NUM'    		,text:'전표번호'		,type : 'int'} 
				,{name: 'PUB_NUM'    		,text:'계산서일자'		,type : 'int'} 
				,{name: 'AP_CHARGE_NAME'    ,text:'승인담당자코드'	,type : 'string'} 
				,{name: 'IN_DIV_CODE'    	,text:'결의사업장코드'	,type : 'string', defaultValue: UserInfo.divCode} 
				,{name: 'IN_DEPT_CODE'    	,text:'결의부서코드'	,type : 'string', defaultValue: UserInfo.deptCode} 
				,{name: 'IN_DEPT_NAME'    	,text:'결의부서명'		,type : 'string', defaultValue: UserInfo.deptName} 
				,{name: 'DEPT_CODE'    		,text:'귀속부서코드'	,type : 'string', defaultValue: UserInfo.deptCode} 
				,{name: 'BILL_DIV_CODE'    	,text:'신고사업장코드'	,type : 'string'} 
				,{name: 'BUSI_TYPE'    		,text:'거래유형'		,type : 'string'} 				
				,{name: 'CREDIT_CODE'    	,text:'신용카드사코드'	,type : 'string'} 
				,{name: 'REASON_CODE'    	,text:'불공제사유코드'	,type : 'string'} 
				,{name: 'CREDIT_NUM'    	,text:'신용카드,현금영수증'	,type : 'int'} 
				,{name: 'AP_STS'    		,text:'승인여부'		,type : 'string'} 
				,{name: 'COMP_CODE'    		,text:'법인코드'		,type : 'string', defaultValue: UserInfo.compCode} 
				,{name: 'DRAFT_YN'    		,text:'DRAFT_YN'		,type : 'string'} 

		]
    })
    
    /**
     * 매입매출전표  Store
     */
	var salesStore = Unilite.createStore('agj100ukrSalesStore',{
			model: 'agj100ukrSaleModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : true			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	   read : 'agj100ukrService.selectList'
//                	,update : 'agj100ukrService.updateMulti'
//					,create : 'agj100ukrService.insertMulti'
//					,destroy:'agj100ukrService.deleteMulti'
//					,syncAll:'agj100ukrService.syncAll'
                }
            }  // proxy
            
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			,saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll(config);
				}else {
					alert(Msg.sMB083);
				}
			}
            
		});
		
    /**
     *  매출/매입 전표 Detail  Grid 정의(Grid Panel)
     * @type 
     */
    var salesGrid = Unilite.createGrid('agj100ukrSalesGrid', {
        flex: 0.35,
        itemId: 'agj100ukrSalesGrid',
		uniOpt:{
        	expandLastColumn: true,
            useMultipleSorting: false            
        },
        border:true,
    	store: salesStore,
		columns:[
			 { dataIndex: 'AC_DAY',  width: 50 } 
			,{ dataIndex: 'PUB_DATE',  width: 100 } 
			,{ dataIndex: 'SALE_DIVI',  width: 100 } 
			,{ dataIndex: 'BUSI_TYPE_NM',  width: 100 } 
			,{ dataIndex: 'CUSTOM_CODE',  width: 80 } 
			,{ dataIndex: 'CUSTOM_NAME',  width: 110 } 
			,{ dataIndex: 'PROOF_KIND_NM',  width: 110 } 
			,{ dataIndex: 'SUPPLY_AMT_I',  width: 100 } 
			,{ dataIndex: 'TAX_AMT_I',  width: 80 } 
			,{ dataIndex: 'REMARK',  width: 150 } 
			,{ dataIndex: 'DEPT_NAME',  width: 100 } 
			,{ dataIndex: 'DIV_CODE',  width: 50 } 
		],
		listeners:{
    		selectionChange: function( gird, selected, eOpts )	{
    			
    			
    		},
    		render: function(grid, eOpts){
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	activeGrid = grid.getItemId();
			    });
			 }
    	}
    });
    
    var saleDetailForm = Unilite.createForm('agj100ukrSaleDetailForm',  {		
        itemId: 'agj100ukrSaleDetailForm',
		masterGrid: masterGrid2,
		//flex: 0.25
		height: 85,
		disabled: false,
		border: true,
		padding: 0,
//		flex: 1,
		layout : 'hbox',
		defaults:{
			labelWidth: 100
		},
		items:[{
			xtype: 'container',
			itemId: 'formFieldArea1',
			layout: {
				type: 'uniTable', 
				columns:2,
				tdAttrs: {
					width: 300
				}
			}
		}]
	});
    
    var tab = Unilite.createTabPanel('agj100ukrvTab',{    	
		region:'center',
    	activeTab: 0,
    	border: false,
    	items:[
    		{
    			title: '일반점표',
				xtype: 'container',
				itemId: 'agj100ukrvTab1',
				layout:{type:'vbox', align:'stretch'},
				items:[
					masterGrid1,
		  			detailForm1
				]
			},{
				title: '매입/매출전표',
				xtype:'container',
				itemId: 'agj100ukrvTab2',
				layout:{type:'vbox', align:'stretch'},
				items:[
					
					salesGrid,
					masterGrid2,
		  			saleDetailForm
				]
			}
    	],
    	listeners:{
    		tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
    			if(newCard.getItemId() == 'agj100ukrvTab1')	{
    				
    			}else {
    				
    			}
    		}
    	}
    })

    Unilite.Main({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		tab, panelResult
         	]	
      	},
      	panelSearch     
      	],
		id  : 'agj100ukrApp',
		autoButtonControl : false,
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons([ 'newData','reset'],true);
			this.processParams(params);
		}
		,onSaveAsExcelButtonDown: function() {
			var masterGrid1 = Ext.getCmp('agj100ukrGrid1');
			 masterGrid1.downloadExcelXml();
		},
		onQueryButtonDown : function()	{
			directMasterStore1.loadStoreRecords();
		},
		onNewDataButtonDown : function()	{
			var activeTab = tab.getActiveTab();
			var activeTabId = activeTab.getItemId();
			if(activeTabId == 'agj100ukrvTab1' )	{
				masterGrid1.createRow();	
			} else if(activeTabId == 'agj100ukrvTab2' )	{
				if(activeGrid=='agj100ukrSalesGrid')	{
					if(!salesStore.isDirty() || !directMasterStore2.isDirty())	{
						var pDate = panelSearch.getValue('AC_DATE_TO');
						var rec={
							 'AC_DATE': Ext.Date.format(pDate, 'Ymd'),
							 'AC_DAY':  Ext.Date.format(pDate,'j'),
							 'PUB_DATE': pDate,
							 'SALE_DIVI': '1',
							 'AP_STS':'1',
							 'SUPPLY_AMT_I': 0,
							 'TAX_AMT_I': 0
						}
						salesGrid.createRow(rec);
					}
				} else {
					if(salesGrid.getSelectedRecord())	{
						var pDate = panelSearch.getValue('AC_DATE_TO');
						var selSalesRecord = salesGrid.getSelectedRecord();
						var selRecord = masterGrid2.getSelectedRecord();
						var rec={
							 'AC_DATE': Ext.Date.format(pDate, 'Ymd'),
							 'AC_DAY':  Ext.Date.format(pDate,'j'),
							 'CUSTOM_CODE': selSalesRecord.data['CUSTOM_CODE'],
							 'CUSTOM_NAME': selSalesRecord.data['CUSTOM_NAME'],
							 'SLIP_NUM' : selRecord != null ? selRecord.data['SLIP_NUM']:''
						}
						masterGrid2.createRow();
					}
				}				
			}
		},	
		onSaveDataButtonDown: function (config) {
			var activeTab = tab.getActiveTab();
			var activeTabId = activeTab.getItemId();
			if(activeTabId == 'agj100ukrvTab1' )	{
				directMasterStore1.saveStore(config);
			} else  if(activeTabId == 'agj100ukrvTab2' )	{
				salesStore.saveStore(config);
				directMasterStore2.saveStore(config);
			}
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid1.deleteSelectedRow();
			}
		},
		onResetButtonDown:function() {
			var masterGrid1 = Ext.getCmp('agj100ukrGrid1');
			panelSearch.reset();			
			
			masterGrid1.reset();
			masterGrid2.reset();
			salesGrid.reset();			
			detailForm1.clearForm();	
			saleDetailForm.clearForm();	
			
			panelSearch.getField('AC_DATE_FR').setReadOnly(false);
			panelSearch.getField('AC_DATE_TO').setReadOnly(false);
			panelSearch.getField('INPUT_PATH').setReadOnly(false);
			
			panelResult.getField('AC_DATE_FR').setReadOnly(false);
			panelResult.getField('AC_DATE_TO').setReadOnly(false);
			panelResult.getField('INPUT_PATH').setReadOnly(false);
			
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
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
			directMasterStore1.rejectChanges();
			directMasterStore2.rejectChanges();
			salesStore.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		}, 
		confirmSaveData: function()	{
			var activeTab = tab.getActiveTab();
			var activeTabId = activeTab.getItemId();
			if(activeTabId == 'agj100ukrvTab1' )	{
				if(directMasterStore1.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
			} else  if(activeTabId == 'agj100ukrvTab2' )	{
				if(salesStore.isDirty() || directMasterStore2.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
			}
			
        },
        //링크로 넘어오는 params 받는 부분 (Agj240skr)
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params && params.DIV_CODE) {
				panelSearch.setValue('AC_DATE_FR',params.AC_DATE_FR);
				panelSearch.setValue('AC_DATE_TO',params.AC_DATE_FR);
				panelSearch.setValue('EX_DATE_FR',params.EX_DATE_FR);
				panelSearch.setValue('EX_DATE_TO',params.EX_DATE_TO);
				panelSearch.setValue('INPUT_PATH',params.INPUT_PATH);
				panelSearch.setValue('SLIP_NUM',params.SLIP_NUM);
				panelSearch.setValue('EX_NUM',params.EX_NUM);
				panelSearch.setValue('SLIP_SEQ',params.SLIP_SEQ);
				panelSearch.setValue('AP_STS',params.AP_STS);
				panelSearch.setValue('DIV_CODE',params.DIV_CODE);
				panelSearch.setValue('CHARGE_NAME',params.CHARGE_NAME);
	/*			panelResult.setValue('AC_DATE_FR',params.AC_DATE_FR);
				panelResult.setValue('AC_DATE_TO',params.AC_DATE_FR);
				panelResult.setValue('EX_DATE_FR',params.EX_DATE_FR);
				panelResult.setValue('EX_DATE_TO',params.EX_DATE_TO);
				panelResult.setValue('INPUT_PATH',params.INPUT_PATH);
				panelResult.setValue('SLIP_NUM',params.SLIP_NUM);
				panelResult.setValue('EX_NUM',params.EX_NUM);
				panelResult.setValue('SLIP_SEQ',params.SLIP_SEQ);
				panelResult.setValue('AP_STS',params.AP_STS);
				panelResult.setValue('DIV_CODE',params.DIV_CODE);
	*/			
				masterGrid1.getStore().loadStoreRecords();
				
/*			panelSearch.getField('AC_DATE_FR').setReadOnly( true );
			panelSearch.getField('AC_DATE_TO').setReadOnly( true );
			panelSearch.getField('EX_DATE_FR').setReadOnly( true );
			panelSearch.getField('EX_DATE_TO').setReadOnly( true );
			panelSearch.getField('INPUT_PATH').setReadOnly( true );
			panelResult.getField('SLIP_NUM').setReadOnly( true );
			panelResult.getField('EX_NUM').setReadOnly( true );
			panelResult.getField('SLIP_SEQ').setReadOnly( true );
			panelResult.getField('AP_STS').setReadOnly( true );
			panelResult.getField('DIV_CODE').setReadOnly( true );
*/			}
		}
	});	// Main
	
	
}; // main


</script>


