<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sat610skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sat610skrv" />				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S175"/>						<!-- 배송방법 -->
	<t:ExtComboStore comboType="AU" comboCode="S178"/>						<!-- 자산정보 -->
	<t:ExtComboStore comboType="AU" comboCode="S179"/>						<!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="S177"/>						<!-- 현재상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B131"/>						<!-- 예/아니오 -->
</t:appConfig>

<style type="text/css">
.search-hr {height: 1px;}
</style>
<script type="text/javascript">

function appMain() {
	
	var inoutTypeStore = Ext.create('Ext.data.Store', {
		storeId : 'CBS_AU_INOUTMETHOD',
	    fields: ['value', 'text'],
	    data : [
	        {'value':'1', 'text':'입고'},
	        {'value':'2', 'text':'출고'},
	        {'value':'3', 'text':'이동'}
	    ]
	});
	
	var inoutMethodStore = Ext.create('Ext.data.Store', {
		
	    fields: ['value', 'text'],
	    data : [
	        {'value':'', 'text':'정상'},
	        {'value':'1', 'text':'연장'},
	        {'value':'2', 'text':'이동'}
	    ]
	});
	
	//마스터 모델
	Unilite.defineModel('sat610skrvModel',{
		fields: [
			{ name:'DIV_CODE'       	, text :'사업장코드'	, type :'string' , comboType : 'BOR120'}
			,{name:'ASST_CODE'      	, text :'자산코드'		, type :'string'  }
			,{name:'ASST_NAME'      	, text :'자산명'		, type :'string'  }
			,{name:'SERIAL_NO'      	, text :'S/N'		, type :'string'  }    
			,{name:'ASST_INFO'      	, text :'자산정보'		, type :'string' , comboType : 'AU' , comboCode : 'S178'}
			,{name:'ASST_GUBUN'     	, text :'자산구분'		, type :'string' , comboType : 'AU' , comboCode : 'S179'}
			,{name:'NOW_LOC'        	, text :'현위치'		, type :'string'  }
			,{name:'ASST_STATUS'    	, text :'현재상태'		, type :'string' , comboType : 'AU' , comboCode : 'S177'}
			,{name:'REQ_NO'         	, text :'출고요청번호'	, type :'string'  }
			,{name:'REQ_SEQ'        	, text :'순번'		, type :'uniPrice'}
			,{name:'REQ_DATE'       	, text :'요청일'		, type :'uniDate' }
			,{name:'REQ_USER_NAME'  	, text :'요청자'		, type :'string'  }
			,{name:'CUSTOM_NAME'    	, text :'발송처'		, type :'string'  }
			,{name:'OUT_DATE'       	, text :'출고일'		, type :'uniDate' }
			,{name:'IN_DATE'   			, text :'입고일'		, type :'uniDate' }
			,{name:'MOVE_CUST_NM1'  	, text :'이동병원1'	, type :'string'  }    
			,{name:'MOVE_REQ_DATE1' 	, text :'이동일1'		, type :'uniDate' }
			,{name:'MOVE_CUST_NM2'  	, text :'이동병원2'	, type :'string'  }    
			,{name:'MOVE_REQ_DATE2' 	, text :'이동일2'		, type :'uniDate' }
			,{name:'USE_GUBUN'      	, text :'사용구분'		, type :'string'  , comboType : 'AU' , comboCode : 'S178'}
			,{name:'RETURN_DATE'    	, text :'반납예정일'	, type :'uniDate' }
			,{name:'RESERVE_YN'     	, text :'예약상태'		, type :'string'  }
			,{name:'RESERVE_DATE'   	, text :'사용예정일'	, type :'uniDate' }
			,{name:'RESERVE_USER_NAME'  , text :'예약담당자'	, type :'string'  } 
		]
	});
	

	// 마스터 스토어 정의
	var masterStore = Unilite.createStore('sat610skrvMasterStore',{
		model	: 'sat610skrvModel',
		proxy	: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read	: 'sat610skrvService.selectList'
			}
		}),
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,	// 삭제 가능 여부
			allDeletable: false,	// 전체 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords: function() {
			var param		= panelResult.getValues();

			console.log(param);
			this.load({
				params : param
			});
		}
	});

	//마스터 폼
	var panelResult =  Unilite.createSearchForm('resultForm',{
		region: 'north',	
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			allowBlank	: false,
			tdAttrs     : {width : 350},
			value		: UserInfo.divCode
		},{
			fieldLabel	: '입출고일',
			startFieldName: 'INOUT_DATE_FR',
			endFieldName  : 'INOUT_DATE_TO',
			xtype       : 'uniDateRangefield',
			startDate   : UniDate.get('aMonthAgo'),
			endDate     : UniDate.today(),
			allowBlank  : false
		},{
			xtype		: 'uniCheckboxgroup',
			fieldLabel	: '현상태',
			name		: 'ASST_STATUS',
			//store       : Ext.data.StoreManager.lookup('inoutMethodStore'),
			comboType   : 'AU',
			comboCode   : 'S177',
			allowBlank  : false,
			initAllTrue : true,
			width       : 400,
			/*  _getStore  : function() {
			    	var storeId = 'inoutMethodStore';
			    	var mStore =	Ext.data.StoreManager.lookup(storeId)
				 	return mStore;
			 } */
		},{
			fieldLabel	: '납품처',
			name		: 'CUSTOM_NAME'
		},{
			fieldLabel	: '자산',
			name		: 'ASST'
		}]
	});// End of var panelResult = Unilite.createSearchForm('searchForm',{
		
	// 마스터 그리드
	var masterGrid = Unilite.createGrid('sat610skrvGrid',{
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			expandLastColumn	: true
		},
		columns	: [
			 {dataIndex:'DIV_CODE'       	, width : 100 , hidden : true}
			,{dataIndex:'ASST_CODE'      	, width : 100 }
			,{dataIndex:'ASST_NAME'      	, width : 150 }
			,{dataIndex:'SERIAL_NO'      	, width : 150 }
			,{dataIndex:'ASST_INFO'      	, width : 80 }
			,{dataIndex:'ASST_GUBUN'     	, width : 80 }
			,{dataIndex:'NOW_LOC'        	, width : 150 }
			,{dataIndex:'ASST_STATUS'    	, width : 80  }
			,{dataIndex:'REQ_NO'       	 	, width : 110 }
			,{dataIndex:'REQ_SEQ'   	 	, width : 50 }
			,{dataIndex:'REQ_DATE'       	, width : 80 }
			,{dataIndex:'REQ_USER_NAME'  	, width : 100 }
			,{dataIndex:'CUSTOM_NAME'    	, width : 150 }
			,{dataIndex:'OUT_DATE'       	, width : 80 }
			,{dataIndex:'IN_DATE'        	, width : 80 }
			,{dataIndex:'MOVE_CUST_NM1'  	, width : 100 }
			,{dataIndex:'MOVE_REQ_DATE1' 	, width : 80 }
			,{dataIndex:'MOVE_CUST_NM2'  	, width : 100 }
			,{dataIndex:'MOVE_REQ_DATE2' 	, width : 80 }
			,{dataIndex:'USE_GUBUN'      	, width : 80 }
			,{dataIndex:'RETURN_DATE'    	, width : 80 }
			,{dataIndex:'RESERVE_YN'     	, width : 80 }
			,{dataIndex:'RESERVE_DATE'   	, width : 80 }
			,{dataIndex:'RESERVE_USER_NAME'	, width : 100 }
		]
	});
	
	
	Unilite.Main( {
		id			: 'sat610skrvApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, 
				masterGrid
			]
		}],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset']	, true);
			this.setDefault();
			
		},
		setDefault: function() {
			
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.getForm().wasDirty = false;
			panelResult.resetDirtyStatus();

			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			masterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterStore.loadData({});
			detailStore.loadData({});
			this.fnInitBinding();
		},
		
	});// End of Unilite.Main( {
};
</script>
