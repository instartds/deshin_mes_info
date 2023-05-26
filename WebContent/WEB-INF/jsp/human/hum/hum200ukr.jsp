<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum200ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->

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
	Unilite.defineModel('Hum200ukrModel1', {
	    fields: [			
			{name: 'COMP_CODE'			, text: '법인코드'			, type: 'string'},
			{name: 'PAYSTEP_YYYYMMDD'	, text: '호봉승급일자'		, type: 'string'},
			{name: 'DEPT_NAME'			, text: '부서'				, type: 'string'},
			{name: 'PAY_GRADE_01'		, text: '급'				, type: 'string'},
			{name: 'PAY_GRADE_02'		, text: '호'				, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'				, type: 'string'},
			{name: 'NAME'				, text: '성명'				, type: 'string'},
			{name: 'PAYSTEP_1'			, text: '초임호봉'			, type: 'number'},
			{name: 'N_PAYSTEP_1'		, text: '초임호봉'			, type: 'string'},
			{name: 'PAYSTEP_CARR'		, text: '인정경력'			, type: 'number'},
			{name: 'N_PAYSTEP_CARR'		, text: '인정경력'			, type: 'string'},
			{name: 'PAYSTEP_LONG_DAY'	, text: '재직'				, type: 'number'},
			{name: 'N_PAYSTEP_LONG_DAY'	, text: '재직'				, type: 'string'},
			{name: 'MODIFY_DAY'			, text: '기산일'			, type: 'number'},
			{name: 'PO_NE_GUBUN'		, text: '기산일'			, type: 'string', comboType:'AU', comboCode:'HP04'},
			{name: 'N_MODIFY_DAY'		, text: '기산일'			, type: 'string'},
			{name: 'N_YYYY'				, text: '기산일'			, type: 'number'},
			{name: 'N_MM'				, text: '기산일'			, type: 'number'},
			{name: 'N_DD'				, text: '기산일'			, type: 'number'},
			{name: 'MODIFY_REASON'		, text: '사유'				, type: 'string'},
			{name: 'BEFORE_MODIFY_DAY'	, text: '전일조정누적계'	, type: 'number'},
			{name: 'N_BEFORE_MODIFY_DAY', text: '전일조정누적계'	, type: 'string'},
			{name: 'DEFER_DAY'			, text: '보류'				, type: 'number'},
			{name: 'N_DEFER_DAY'		, text: '보류'				, type: 'string'},
			{name: 'PAYSTEP_TOT_DAY'	, text: 'PAYSTEP_TOT_DAY'	, type: 'number'},
			{name: 'N_TOT_YYYY'			, text: 'N_TOT_YYYY'		, type: 'number'},
			{name: 'N_TOT_MM'			, text: 'N_TOT_MM'			, type: 'number'},
			{name: 'N_TOT_DD'			, text: 'N_TOT_DD'			, type: 'number'},
			{name: 'N_BEFORE_TOT_YYYY'	, text: 'N_BEFORE_TOT_YYYY'	, type: 'number'},
			{name: 'N_BEFORE_TOT_MM'	, text: 'N_BEFORE_TOT_MM'	, type: 'number'},
			{name: 'N_BEFORE_TOT_DD'	, text: 'N_BEFORE_TOT_DD'	, type: 'number'},
			{name: 'TOT_DAY_CONVERT'	, text: '환산계'			, type: 'string'},
			{name: 'N_TOT_DAY_CONVERT'	, text: '환산계'			, type: 'string'}			
	    ]
	});
	
	Unilite.defineModel('Hum200ukrModel2', {
	    fields: [
			{name: 'CHOICE'				, text: '선택'			, type: 'boolean'},
			{name: 'COMP_CODE'			, text: '법인코드'		, type: 'string'},
			{name: 'PAYSTEP_YYYYMMDD'	, text: '호봉승급일자'	, type: 'string'},			
			{name: 'DEPT_NAME'			, text: '부서'			, type: 'string'},
			{name: 'PAY_GRADE_01'		, text: '급'			, type: 'string'},
			{name: 'PAY_GRADE_02'		, text: '호'			, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'			, type: 'string'},
			{name: 'NAME'				, text: '성명'			, type: 'string'},
			{name: 'TOT_DAY_CONVERT'	, text: '환산계'		, type: 'string'},
			{name: 'EXPECT_PAY_GRADE'	, text: '승급예상호봉'	, type: 'string'},
			{name: 'EXPECT_GUBUN'		, text: '승급대상여부'	, type: 'string'},
			{name: 'EXPECT_YYYYMMDD'	, text: '만료일'		, type: 'string'},
			{name: 'EXPECT_REMARK'		, text: '사유'			, type: 'string'}
		]
	});	

	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('hum200ukrMasterStore1',{
		model: 'Hum200ukrModel1',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {            	
                read: 'hum200ukrService.selectList1',
                create: 'hum200ukrService.update',
                update: 'hum200ukrService.update',                
                syncAll: 'hum200ukrService.syncAll'
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( "param",param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{				
 			var inValidRecs = this.getInvalidRecords();
 			console.log("inValidRecords : ", inValidRecs);
 			if(inValidRecs.length == 0 )	{
 				this.syncAll();					
 			}else {
 				alert(Msg.sMB083);
 			}
 		}
// 		groupField: 'ITEM_NAME'
	});
	
	var directMasterStore2 = Unilite.createStore('hum200ukrMasterStore2',{
		model: 'Hum200ukrModel2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hum200ukrService.selectList2',
                create: 'hum200ukrService.update2',
                update: 'hum200ukrService.update2',                
                syncAll: 'hum200ukrService.syncAll'
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
// 		groupField: 'ITEM_NAME'
	});
	
		
	var baseMenu = {	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [
		    {	
    			fieldLabel: '호봉승급일자',
	        	name: 'PAYSTEP_YYYYMMDD', 
	        	id: 'PAYSTEP_YYYYMMDD',
	        	value: Ext.Date.getFirstDateOfMonth(new Date()),
	        	allowBlank: false,
	        	xtype: 'uniDatefield'	        	     				
			},
		    { 
	        	fieldLabel: '사업장',
	        	name: 'DIV_CODE', 
	        	id: 'DIV_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType:'BOR120',
	        	value :'01'      	
        	},
        	{	
    			fieldLabel: '급여지급방식',
	        	name: 'PAY_CODE', 
	        	id: 'PAY_CODE', 
	        	xtype: 'uniCombobox', 
	        	comboType:'AU',
	        	comboCode:'H028'
			},
			    Unilite.popup('DEPT',{ 
					    fieldLabel: '부서', 
					    textFieldWidth: 170, 
					    validateBlank: false, 
					    popupWidth: 400
				}),   	
					Unilite.popup('DEPT',{ 
					    fieldLabel: '~',
					    valueFieldName: 'DEPT_CODE2',
				    	textFieldName: 'DEPT_NAME2',
					    textFieldWidth: 170, 
					    validateBlank: false, 
					    popupWidth: 400
				}),					
					Unilite.popup('Employee',{ 
					     
					    textFieldWidth: 170, 
					    validateBlank: false, 
					    popupWidth: 400
				}),
				{
	        		xtype: 'container',
	        		width: 350,
	        		layout: {type: 'hbox'},
	        		items:[
						{        		    	   	
							fieldLabel: '급호',
							id: 'PAY_GRADE_01',
							name: 'PAY_GRADE_01',
							xtype: 'uniTextfield',
							suffixTpl: '급',
							width: 210																				
						},
						{
							id: 'PAY_GRADE_02',
							name: 'PAY_GRADE_02',
							xtype: 'uniTextfield',
							suffixTpl: '호',
							width: 110										
						}
	        		    	   
		        	]	        	
				}
				
			]};
		
	
// 	var menu1 = {
// 			title:'추가정보',
// 				id: 'menu1',
// 			itemId:'menu1',    		
//     		items:[
//     		{	
//     			fieldLabel: '학교명',
// 	        	name: 'SCHOOL_NAME', 
// 	        	id: 'SCHOOL_NAME', 
// 	        	xtype: 'uniTextfield'	        	     				
// 			},
// 		]				
// 	};
	var menu1 = {
    		xtype: 'button',
    		text: '재참조',
    		margin: '10 100 0 100',
    		handler: function(){
    			
    			Ext.Msg.show({
    			    title:'',    			    
    			    msg: '재참조시 기존 '+Ext.getCmp('PAYSTEP_YYYYMMDD').rawValue + ' 날짜로 등록된 승급대상관리가 삭제됩니다. 계속하시겠습니까?',
    			    buttons: Ext.Msg.YESNO,
    			    icon: Ext.Msg.QUESTION,
    			    fn: function(btn) {
    			        if (btn === 'yes') {
    			        	runProc();
    			        } else if (btn === 'no') {
    			            this.close();
    			        } 
    			    }
    			});

    		}
    	};
	
	var menu2 = {
	    	xtype: 'container',
	    	margin: '10 100 0 100',	    	
	    	layout: {
	    		type: 'hbox',
				align: 'center',
				pack:'center'
	    	},
	    	items:[
	    	 {
	    		xtype: 'button',
	    		id: 'select',
	    		width: 140,
	    		text: '전체선택',
	    		handler: function(){			    						    		
	    			SelectAll();  			
	    		}
	    	},{
	    		xtype: 'button',
	    		id: 'deselect',
	    		width: 140,
	    		text: '전체해제',
	    		hidden: true,
	    		handler: function(){			    						    		
	    			DeSelectAll();  			
	    		}
	    	}]
	    };	
	
	// 프로시져 실행
	function runProc() {		
		var form = panelSearch.getForm();
		if (form.isValid()) {
			//Ajax
			var param= Ext.getCmp('searchForm').getValues();		
					
				Ext.Ajax.on("beforerequest", function(){
					Ext.getBody().mask('로딩중...', 'loading')
			    }, Ext.getBody());
				Ext.Ajax.on("requestcomplete", Ext.getBody().unmask, Ext.getBody());
				Ext.Ajax.on("requestexception", Ext.getBody().unmask, Ext.getBody());
				
				Ext.Ajax.request({
					url     : CPATH+'/human/fnHum240QStd2.do',
					params: param,
					success: function(response){
	 					data = Ext.decode(response.responseText);
	 					console.log("data:::",data);

	 					directMasterStore1.loadData(data);
	 											
					},
					failure: function(response){
						console.log(response);
						Ext.Msg.alert('실패', response.statusText);
					}
				});
				
		} else {
			var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
				return !field.validate();
			});
			    	
			if(invalid.length > 0)	{
				r = false;
				var labelText = ''
				    	
				if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				}
				
				// Ext.Msg.alert(타이틀, 표시문구); 
				Ext.Msg.alert('확인', labelText+Msg.sMB083);
				// validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
				invalid.items[0].focus();
			}
		}	
		
    }
	
	function SelectAll(){		
		var grid = Ext.getCmp('hum200ukrGrid2');
		var button1 = Ext.getCmp('select');
		var button2 = Ext.getCmp('deselect');
		var model = grid.getStore().getRange();			
				
		Ext.each(model, function(record,i){
			record.set('CHOICE',true);						    			
		});
		
		button1.setVisible(false);
		button2.setVisible(true);	
	}
	
	function DeSelectAll(){
		var grid = Ext.getCmp('hum200ukrGrid2');
		var button1 = Ext.getCmp('select');
		var button2 = Ext.getCmp('deselect');
		var model = grid.getStore().getRange();
		
		Ext.each(model, function(record,i){
			record.set('CHOICE',false);						    			
		});
		button1.setVisible(true);
		button2.setVisible(false);
	}
	
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
		items: [baseMenu, menu1]		
	});	//end panelSearch
	
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
     var masterGrid1 = Unilite.createGrid('hum200ukrGrid1', {
     	title: '승급대상관리',
     	layout : 'fit',
         region : 'center',
         store : directMasterStore1, 
         uniOpt:{	expandLastColumn: false,
         			useRowNumberer: true,
                     useMultipleSorting: true
         },
         
         columns: [
					{dataIndex: 'COMP_CODE'					, width: 80, hidden: true, locked: true },
					{dataIndex: 'PAYSTEP_YYYYMMDD'		, width: 80, hidden: true, locked: true },
					{dataIndex: 'DEPT_NAME'						, width: 80, locked: true, editable: false },
					{dataIndex: 'PAY_GRADE_01'				, width: 80, locked: true, editable: false },
					{dataIndex: 'PAY_GRADE_02'				, width: 80, locked: true, editable: false },
					{dataIndex: 'PERSON_NUMB'					, width: 80, locked: true, editable: false },
					{dataIndex: 'NAME'								, width: 80, locked: true, editable: false },
					{dataIndex: 'PAYSTEP_1'						, width: 150, editable: false },
					{dataIndex: 'N_PAYSTEP_1'					, width: 150, hidden: true, editable: false },
					{dataIndex: 'PAYSTEP_CARR'				, width: 150, editable: false },
					{dataIndex: 'N_PAYSTEP_CARR'				, width: 150, hidden: true, editable: false },
					{dataIndex: 'PAYSTEP_LONG_DAY'			, width: 150, editable: false },
					{dataIndex: 'N_PAYSTEP_LONG_DAY'		, width: 150, hidden: true, editable: false },
					{text: '조정',
						columns:[
						{dataIndex: 'PO_NE_GUBUN'					, width: 150 },
						{dataIndex: 'MODIFY_DAY'					, width: 150 },												
						{dataIndex: 'MODIFY_REASON'				, width: 150 }
					]},	
					
					{dataIndex: 'N_MODIFY_DAY'				, width: 150, hidden: true, editable: false },
					{dataIndex: 'N_YYYY'							, width: 150, hidden: true, editable: false },
					{dataIndex: 'N_MM'								, width: 150, hidden: true, editable: false },
					{dataIndex: 'N_DD'								, width: 150, hidden: true, editable: false },					
					{dataIndex: 'BEFORE_MODIFY_DAY'		, width: 150, editable: false },
					{dataIndex: 'N_BEFORE_MODIFY_DAY'	, width: 150, hidden: true, editable: false },
					{dataIndex: 'DEFER_DAY'						, width: 150, editable: false },
					{dataIndex: 'N_DEFER_DAY'					, width: 150, hidden: true, editable: false },
					{dataIndex: 'PAYSTEP_TOT_DAY'			, width: 150, hidden: true, editable: false },
					{dataIndex: 'N_TOT_YYYY'					, width: 150, hidden: true, editable: false },
					{dataIndex: 'N_TOT_MM'						, width: 150, hidden: true, editable: false },
					{dataIndex: 'N_TOT_DD'						, width: 150, hidden: true, editable: false },
					{dataIndex: 'N_BEFORE_TOT_YYYY'		, width: 150, hidden: true, editable: false },
					{dataIndex: 'N_BEFORE_TOT_MM'			, width: 150, hidden: true, editable: false },
					{dataIndex: 'N_BEFORE_TOT_DD'			, width: 150, hidden: true, editable: false },
					{dataIndex: 'TOT_DAY_CONVERT'			, width: 150, editable: false },
					{dataIndex: 'N_TOT_DAY_CONVERT'		, width: 150, hidden: true, editable: false }
					
					
// 					{dataIndex: 'COMP_CODE'					, width: 80, hidden: true, locked: true },
// 					{dataIndex: 'PAYSTEP_YYYYMMDD'		, width: 80, hidden: true, locked: true },
// 					{dataIndex: 'DEPT_NAME'						, width: 80, locked: true },
// 					{dataIndex: 'PAY_GRADE_01'				, width: 80, locked: true },
// 					{dataIndex: 'PAY_GRADE_02'				, width: 80, locked: true },
// 					{dataIndex: 'PERSON_NUMB'					, width: 80, locked: true },
// 					{dataIndex: 'NAME'								, width: 80, locked: true },
// 					{dataIndex: 'PAYSTEP_1'						, width: 150, hidden: true },
// 					{dataIndex: 'N_PAYSTEP_1'					, width: 150 },
// 					{dataIndex: 'PAYSTEP_CARR'				, width: 150, hidden: true },
// 					{dataIndex: 'N_PAYSTEP_CARR'				, width: 150 },
// 					{dataIndex: 'PAYSTEP_LONG_DAY'			, width: 150, hidden: true },
// 					{dataIndex: 'N_PAYSTEP_LONG_DAY'		, width: 150 },
// 					{dataIndex: 'MODIFY_DAY'					, width: 150, hidden: true },
// 					{dataIndex: 'PO_NE_GUBUN'					, width: 150 },
// 					{dataIndex: 'N_MODIFY_DAY'				, width: 150 },
// 					{dataIndex: 'N_YYYY'							, width: 150, hidden: true },
// 					{dataIndex: 'N_MM'								, width: 150, hidden: true },
// 					{dataIndex: 'N_DD'								, width: 150, hidden: true },
// 					{dataIndex: 'MODIFY_REASON'				, width: 150 },
// 					{dataIndex: 'BEFORE_MODIFY_DAY'		, width: 150, hidden: true },
// 					{dataIndex: 'N_BEFORE_MODIFY_DAY'	, width: 150 },
// 					{dataIndex: 'DEFER_DAY'						, width: 150, hidden: true },
// 					{dataIndex: 'N_DEFER_DAY'					, width: 150 },
// 					{dataIndex: 'PAYSTEP_TOT_DAY'			, width: 150, hidden: true },
// 					{dataIndex: 'N_TOT_YYYY'					, width: 150, hidden: true },
// 					{dataIndex: 'N_TOT_MM'						, width: 150, hidden: true },
// 					{dataIndex: 'N_TOT_DD'						, width: 150, hidden: true },
// 					{dataIndex: 'N_BEFORE_TOT_YYYY'		, width: 150, hidden: true },
// 					{dataIndex: 'N_BEFORE_TOT_MM'			, width: 150, hidden: true },
// 					{dataIndex: 'N_BEFORE_TOT_DD'			, width: 150, hidden: true },
// 					{dataIndex: 'TOT_DAY_CONVERT'			, width: 150, hidden: true },
// 					{dataIndex: 'N_TOT_DAY_CONVERT'		, width: 150 }


                    
               ]   	        
     });
     

     var masterGrid2 = Unilite.createGrid('hum200ukrGrid2', {
      	title: '승급확정',
      	layout : 'fit',
          region : 'center',
          store : directMasterStore2, 
          uniOpt:{	expandLastColumn: false,
          			useRowNumberer: true,
                      useMultipleSorting: true
          },
          
          columns: [        
				{dataIndex: 'CHOICE'						, width: 80, locked: true, xtype : 'checkcolumn' },		//선택
				{dataIndex: 'COMP_CODE'				, width: 80, hidden: true },		//법인코드
				{dataIndex: 'PAYSTEP_YYYYMMDD'	, width: 80, hidden: true },		//호봉승급일자			
				{dataIndex: 'DEPT_NAME'					, width: 80, locked: true },		//부서
				{dataIndex: 'PAY_GRADE_01'			, width: 80, locked: true },		//급
				{dataIndex: 'PAY_GRADE_02'			, width: 80, locked: true },		//호
				{dataIndex: 'PERSON_NUMB'				, width: 80, locked: true },		//사번
				{dataIndex: 'NAME'							, width: 80, locked: true },		//성명
				{dataIndex: 'TOT_DAY_CONVERT'		, width: 150 },		//환산계
				{dataIndex: 'EXPECT_PAY_GRADE'		, width: 150 },		//승급예상호봉
				{dataIndex: 'EXPECT_GUBUN'			, width: 150 },		//승급대상여부
				{text: '조정',
					columns:[
					{dataIndex: 'EXPECT_YYYYMMDD'		, width: 150 },		//만료일
					{dataIndex: 'EXPECT_REMARK'			, width: 150 }		//사유
				]}
               
          ]  	        
      });     
	
	
	/**
     * TabPanel 정의(Tab)
     * @type 
     */
     var tabPanel = Ext.create('Ext.tab.Panel',{    	 
         region : 'center',
         layout: {type: 'vbox', align: 'stretch'},
 		 bodyCls: 'human-panel-form-background',
 		 items: [
 		         masterGrid1,
 		         masterGrid2 		         
 		 ],
 		 listeners: {
 			 tabchange: function(){
 				var activeTabId = tabPanel.getActiveTab().getId();
 				panelSearch.removeAll(); 
 				panelSearch.add(baseMenu);
 				
 				if(activeTabId == 'hum200ukrGrid1'){
 					panelSearch.add(menu1);
 				 }else if(activeTabId == 'hum200ukrGrid2'){ 					
 					 panelSearch.add(menu2);
 				 }
 				panelSearch.doLayout();
 			 }
 		 }
     })
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[ 
		 		 tabPanel
				,panelSearch
		], 
		id : 'hum200ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('delete',false);
			UniAppManager.setToolbarButtons('newData',false);
		},
		onQueryButtonDown : function()	{		
			var activeTabId = tabPanel.getActiveTab().getId();
			
			if(activeTabId == 'hum200ukrGrid1'){				
				directMasterStore1.loadStoreRecords();				
			}else if(activeTabId == 'hum200ukrGrid2'){				
				directMasterStore2.loadStoreRecords();				
			}
// 			var viewLocked = tab.getActiveTab().lockedGrid.getView();
// 			var viewNormal = tab.getActiveTab().normalGrid.getView();
// 			console.log("viewLocked : ",viewLocked);
// 			console.log("viewNormal : ",viewNormal);
// 			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
// 			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
// 			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
// 			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onSaveDataButtonDown : function(){
			var activeTabId = tabPanel.getActiveTab().getId();
			if(activeTabId == 'hum200ukrGrid1'){
				Ext.getCmp('hum200ukrGrid1').getStore().syncAll();
				directMasterStore1.loadStoreRecords();
			}else if(activeTabId == 'hum200ukrGrid2'){				
				Ext.getCmp('hum200ukrGrid2').getStore().syncAll();
				DeSelectAll();
				directMasterStore2.loadStoreRecords();				
			}			
		},		
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};


</script>