<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//사용자 정보 등록
request.setAttribute("PKGNAME","Unilite_app_bsa300ukrv");
%>
<t:appConfig pgmId="bsa300ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>								<!-- 사업장 -->
	<!--<t:ExtComboStore comboType="AU" comboCode="B001" /> 사업장    -->
	<t:ExtComboStore comboType="AU" comboCode="B063" /><!-- 참조명칭 -->
	<t:ExtComboStore comboType="AU" comboCode="B245" /><!-- 사용자LEVEL -->
	<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 사용여부, 잠금여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" /><!-- ERP_USER 여부 -->
	<t:ExtComboStore comboType="AU" comboCode="CM10" /><!-- 권한레벨 -->
	<t:ExtComboStore comboType="AU" comboCode="YP39" /><!-- 포스레벨 -->
	<t:ExtComboStore comboType="AU" comboCode="B131" /><!-- 예/아니오 -->
</t:appConfig>

<script type="text/javascript" >
function appMain() {
var BsaCodeInfo = {
	gsSyTalkYn     : '${gsSyTalkYn}'
};

var syTalkColYn = true;
if(BsaCodeInfo.gsSyTalkYn == 'Y'){
	syTalkColYn = false ;
}
	/**
	 * Model 정의
	 * @type
	 */

	Unilite.defineModel('${PKGNAME}Model', {
		// pkGen : user, system(default)
	    fields: [ 	 {name: 'SEQ' 				,text:'<t:message code="system.label.base.seq" default="순번"/>' 				,type:'int'			,editable:false}
					,{name: 'USER_ID' 			,text:'<t:message code="system.label.base.userid" default="사용자ID"/>' 			,type:'string'		,allowBlank:false, isPk:true}
					,{name: 'USER_NAME' 		,text:'<t:message code="system.label.base.username" default="사용자명"/>' 			,type:'string'		,allowBlank:false}
					,{name: 'PASSWORD' 			,text:'<t:message code="system.label.base.password" default="비밀번호"/>' 			,type:'uniPassword'	,allowBlank:false	}
					,{name: 'PERSON_NUMB' 		,text:'<t:message code="system.label.base.personnumb" default="사번"/>' 				,type:'string'}
					,{name: 'NAME' 				,text:'<t:message code="system.label.base.employeename" default="사원명"/>' 				,type:'string'}
					,{name: 'ERP_USER' 			,text:'<t:message code="system.label.base.erpuser" default="ERP사용자"/>' 			,type:'string'		,comboType:'AU',comboCode:'A020', defaultValue:'Y'}
					,{name: 'DEPT_CODE' 		,text:'<t:message code="system.label.base.department" default="부서"/>' 				,type:'string'		,allowBlank:false, editable:false}
					,{name: 'DEPT_NAME' 		,text:'<t:message code="system.label.base.departmentname" default="부서명"/>' 				,type:'string'		,editable:false}
					//,{name: 'DIV_CODE' 			,text:'<t:message code="system.label.base.division" default="사업장"/>' 				,type:'string'		,allowBlank:false, comboType:'AU',comboCode:'B001'}
					,{name: 'DIV_CODE' 			,text:'<t:message code="system.label.base.division" default="사업장"/>' 				,type:'string'		,allowBlank:false, comboType:'BOR120'}
					,{name: 'REF_ITEM' 			,text:'<t:message code="system.label.base.refitem" default="참조명칭"/>' 			,type:'string'		,comboType:'AU',comboCode:'B063', defaultValue:'0'}
					,{name: 'POS_ID' 			,text:'<t:message code="system.label.base.posid" default="포스ID"/>' 				,type:'string'}
					,{name: 'POS_PASS' 			,text:'<t:message code="system.label.base.pospass" default="포스비밀번호 (DB)"/>' 	,type:'uniPassword'}
					,{name: 'POS_LEVEL' 		,text:'<t:message code="system.label.base.poslavel" default="포스권한레벨"/>' 		,type:'string'		,comboType:'AU',comboCode:'YP39'}
					,{name: 'EMAIL_ADDR'        ,text:'<t:message code="system.label.base.emailaddr" default="이메일주소"/>'          ,type:'string'}
					,{name: 'AUTHORITY_LEVEL' 	,text:'<t:message code="system.label.base.authoritylevel" default="권한레벨"/>' 			,type:'string'		,allowBlank:false ,comboType:'AU',comboCode:'CM10', defaultValue:'15'}
					,{name: 'USE_YN' 			,text:'<t:message code="system.label.base.useyn" default="사용여부"/>' 			,type:'string'		,allowBlank:false ,comboType:'AU',comboCode:'B010', defaultValue:'Y'}
					,{name: 'PWD_UPDATE_DATE'	,text:'<t:message code="system.label.base.passupdatedate" default="비밀번호변경일"/>'		,type:'uniDate'		,editable:false, defaultValue:UniDate.today()}
					,{name: 'FAIL_CNT' 			,text:'<t:message code="system.label.base.loginfailcnt" default="로그인실패횟수"/>' 		,type:'int'			,defaultValue:0}
					,{name: 'LOCK_YN' 			,text:'<t:message code="system.label.base.lockyn" default="잠금여부"/>' 			,type:'string'		,comboType:'AU',comboCode:'A020' , defaultValue:'N'}
					,{name: 'UPDATE_DB_USER' 	,text:'<t:message code="system.label.base.updateuser" default="수정자"/>' 				,type:'string'		,defaultValue:UserInfo.userName, editable:false}
					,{name: 'UPDATE_DB_TIME' 	,text:'<t:message code="system.label.base.updatedate" default="수정일"/>' 				,type:'uniDate'		,editable:false, defaultValue:UniDate.today()}
					,{name: 'COMP_CODE' 		,text:'<t:message code="system.label.base.companycode" default="법인코드"/>' 			,type:'string'		,isPk:true,  defaultValue:UserInfo.compCode}
					,{name: 'IS_PW_CHANGE' 		,text:'IS_PW_CHANGE'		,type:'string'		,defaultValue:'N'}
					,{name: 'SSO_USER' 			,text:'<t:message code="system.label.base.ssouser" default="SSO사용자"/>'			,type:'string'		,defaultValue:'N'}
					,{name: 'USER_LEVEL'		,text:'<t:message code="system.label.base.userlevel" default="사용자레벨"/>'			,type:'string'		,comboType:'AU',comboCode:'B245' }
					,{name: 'SYTALK_ID'			,text:'SYTALK_ID'			,type:'string'	}
					,{name: 'REMARK' 			,text:'<t:message code="system.label.base.remarks" default="비고"/>'				,type:'string'}
					,{name: 'MENU_DISPLAY_YN' 	,text:'권한없는메뉴표시'				,type:'string'  ,comboType:'AU',comboCode:'B131' }
			]
	});

  	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	   read : 'bsa300ukrvService.selectList'
        	,update : 'bsa300ukrvService.updateMulti'
			,create : 'bsa300ukrvService.insertMulti'
			,destroy: 'bsa300ukrvService.deleteMulti'
			,syncAll: 'bsa300ukrvService.saveAll'
        }
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('${PKGNAME}MasterStore',{
			model: '${PKGNAME}Model',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: directProxy
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('${PKGNAME}searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기
			,saveStore : function()	{
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					//this.syncAll({});
					this.syncAllDirect();
				}else {
					var grid = Ext.getCmp('${PKGNAME}Grid');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}

		});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchForm('${PKGNAME}searchForm',{
        layout : {type : 'uniTable' , columns: 3 },
        items: [
        	{
        		fieldLabel: '<t:message code="system.label.base.userid" default="사용자ID"/>',
        		name:'USER_ID'
        	},{
        		fieldLabel: '<t:message code="system.label.base.username" default="사용자명"/>' ,
        		name:'USER_NAME'
        	},{
        		fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>' ,
        		name:'USE_YN',
        		xtype: 'uniCombobox',
        		comboType:'AU',
        		comboCode:'B010',
        		allowBlank:true
        	}
		]
    });

    /**
     * Master Grid 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
    	store: directMasterStore,
    	uniOpt: {
    		useRowNumberer: false
    	},
		columns:[{dataIndex:'SEQ'			,width:50, align:'center'}
				,{dataIndex:'USER_ID'		,width:80}
				,{dataIndex:'USER_NAME'		,width:80}
				,{dataIndex:'PASSWORD'		,width:80}
				,{dataIndex:'PERSON_NUMB'	,width:80,
			     'editor' : Unilite.popup('Employee_G',{
						textFieldName:'PERSON_NUMB',
						DBtextFieldName: 'PERSON_NUMB',
						validateBlank : true,
			  			autoPopup: true,
	   					listeners: {'onSelected': {
		 								fn: function(records, type) {
		 									UniAppManager.app.fnHumanCheck(records);
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
										var grdRecord = Ext.getCmp('${PKGNAME}Grid').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
		 							}
		 				}
					})
				 }
				,{dataIndex:'NAME'				,width:100
				  ,'editor' : Unilite.popup('Employee_G',{
						validateBlank : true,
			  			autoPopup: true,
		  				listeners: {'onSelected': {
			 								fn: function(records, type) {
			 									UniAppManager.app.fnHumanCheck(records);
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('${PKGNAME}Grid').uniOpt.currentRecord;
			  								grdRecord.set('PERSON_NUMB','');
			  								grdRecord.set('NAME','');
			 							}
			 				}
						})
				 }
				,{dataIndex:'ERP_USER'			,width:100	, hidden:true}
				,{dataIndex:'DEPT_CODE'			,width:80
				  ,'editor' : Unilite.popup('DEPT_G',{
				  		textFieldName:'DEPT_CODE',
				  		textFieldWidth:100,
				  		DBtextFieldName: 'TREE_CODE',
			  			autoPopup: true,
				    	listeners: {
				    		'onSelected': {
								fn: function(records, type) {
									UniAppManager.app.fnDeptChange(records);
								},
								scope: this
							},
							'onClear': function(type) {
								var grdRecord = Ext.getCmp('${PKGNAME}Grid').uniOpt.currentRecord;
	    						grdRecord.set('DEPT_CODE','');
		                    	grdRecord.set('DEPT_NAME','');
							}
						}
					})
				}
				,{dataIndex:'DEPT_NAME'			,width:100
				  ,'editor' : Unilite.popup('DEPT_G',{
				  		textFieldName:'DEPT_NAME',
				  		textFieldWidth:100,
				  		DBtextFieldName: 'TREE_NAME',
			  			autoPopup: true,
						listeners: {
							'onSelected': {
 								fn: function(records, type) {
 									UniAppManager.app.fnDeptChange(records);
 								},
 								scope: this
 							},
 							'onClear': function(type) {
 								var grdRecord = Ext.getCmp('${PKGNAME}Grid').uniOpt.currentRecord;
		                    	grdRecord.set('DEPT_CODE','');
		                    	grdRecord.set('DEPT_NAME','');
 							}
		 				}
					})
				 },
        		 {dataIndex:'DIV_CODE'			,width:100}
				,{dataIndex:'REF_ITEM'			,width:80	}
				,{dataIndex:'EMAIL_ADDR'        ,width:150   }
				,{dataIndex:'AUTHORITY_LEVEL'	,width:80	}
				,{dataIndex:'USE_YN'			,width:80	}
				,{dataIndex:'PWD_UPDATE_DATE'	,width:110 	}
				,{dataIndex:'FAIL_CNT'			,width:110 	}
				,{dataIndex:'LOCK_YN'			,width:80}
				,{dataIndex:'UPDATE_DB_USER'	,width:100	}
				,{dataIndex:'UPDATE_DB_TIME'	,width:100	}
				,{dataIndex:'COMP_CODE'			,width:100	,hidden:true}
				,{dataIndex:'IS_PW_CHANGE'		,width:66	,hidden:true}
				,{dataIndex:'SSO_USER'			,width:66	,hidden:true}
				,{dataIndex:'SYTALK_ID'			,width:100	,hidden:syTalkColYn}
				,{dataIndex:'USER_LEVEL'		,width:100}
				,{dataIndex:'MENU_DISPLAY_YN'    ,width:130}
          ]
    });

  	Unilite.Main({
		items : [panelSearch, 	masterGrid],
		id  : 'bsa300ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData'],true);
		},
		onQueryButtonDown : function() {
			directMasterStore.loadStoreRecords();
		},
		onSaveAndQueryButtonDown : function()	{
			this.onSaveDataButtonDown();
			this.onQueryButtonDown();
		},
		onNewDataButtonDown : function()	{
	         var seq = masterGrid.getStore().max('SEQ');
        	 if(!seq) seq = 1;
        	 else  seq += 1;
            param = {'SEQ':seq}
	        masterGrid.createRow(param);
		},

		onSaveDataButtonDown: function () {
			var masterGrid = Ext.getCmp('${PKGNAME}Grid');
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown : function()	{
			masterGrid.deleteSelectedRow();
		},
		onResetButtonDown:function() {
			var masterGrid = Ext.getCmp('${PKGNAME}Grid');
			Ext.getCmp('${PKGNAME}searchForm').getForm().reset();
			masterGrid.getStore().loadData({});
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		},

		fnHumanCheck: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
			grdRecord.set('NAME', record.NAME);

			if(Ext.isEmpty(grdRecord.get('USER_ID'))){
				grdRecord.set('USER_ID', record.PERSON_NUMB);
			}

			if(Ext.isEmpty(grdRecord.get('USER_NAME'))){
				grdRecord.set('USER_NAME', record.NAME);
			}

			if(Ext.isEmpty(grdRecord.get('DEPT_CODE'))){
				grdRecord.set('DEPT_CODE', record.DEPT_CODE);
			}

			if(Ext.isEmpty(grdRecord.get('DEPT_NAME'))){
				grdRecord.set('DEPT_NAME', record.DEPT_NAME);
			}

			if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
				grdRecord.set('DIV_CODE', record.SECT_CODE);
			}
		},

		fnDeptChange: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('DEPT_CODE', record.TREE_CODE);
			grdRecord.set('DEPT_NAME', record.TREE_NAME);
			if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
				grdRecord.set('DIV_CODE', record.DIV_CODE);
			}
		},
		fnShopChange: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
				grdRecord.set('DIV_CODE', record.DIV_CODE);
			}
		}
	});

	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			switch(fieldName) {
				case "PASSWORD" :
					if(newValue != oldValue){
						record.set('IS_PW_CHANGE', 'Y');
					}
					break;

				case "POS_ID" :
					if(isNaN(newValue)){
						rv = Msg.sMB074;	//숫자만 입력 가능합니다.
						break;
					}
					break;

				case "POS_PASS" :
					if(isNaN(newValue)){
						rv = Msg.sMB074;	//숫자만 입력 가능합니다.
						break;
					}
					break;
			}
			return rv;
		}
	});

};


</script>
