<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbs810ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A093" /> <!-- 재무제표양식차수 -->
	<t:ExtComboStore comboType="AU" comboCode="B042"  /> 			<!-- 금액단위 -->
	<t:ExtComboStore comboType="AU" comboCode="H005"  /> 
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
	//1
	
	 Unilite.defineModel('Hbs810ukrModel', {
	   fields: [
			{name: 'DEPT_NAME'			, text: '부서'				, type: 'string'},
			{name: 'DEPT_CODE'			, text: '부서코드'				, type: 'string'},
			{name: 'POST_CODE'			, text: '직위'				, type: 'string', comboType:'AU', comboCode:'H005'},
			{name: 'NAME'				, text: '성명'				, type: 'string'},
			{name: 'PERSON_NUMB'		, text: '사번'				, type: 'string'},
			{name: 'DATE'				, text: '입사일'				, type: 'uniDate'}

	    ]
	});		// End of Ext.define('Hbs810ukrModel', {
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hbs810ukrMasterStore',{
		model: 'Hbs810ukrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hbs810ukrService.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	//2
	Unilite.defineModel('Hbs810ukr2Model', {
		   fields: [
				{name: 'CHK'			, text: '제출'				, type: 'boolean'},
				{name: 'PERSON_NUMB'	, text: '사번'				, type: 'string'},
				{name: 'DOC_TYPE'		, text: '직위'				, type: 'string'},
				{name: 'DOC_ID'			, text: '서류코드'				, type: 'string'},
				{name: 'DOC_NAME'		, text: '서류명'				, type: 'string'},
				{name: 'DOC_YYYY'		, text: '년도'				, type: 'uniDate'}
		    ]
		});		// End of Ext.define('Hbs810ukrModel', {
		  
		/**
		 * Store 정의(Service 정의)
		 * @type 
		 */					
		var directMasterStore2 = Unilite.createStore('hbs810ukrMasterStore2',{
			model: 'Hbs810ukr2Model',
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
	                read: 'hbs810ukrService.selectList2',
	            	//destroy: 'hbs810ukrService.deleteList',
					update: 'hbs810ukrService.updateHbst810t',
					syncAll: 'hbs810ukrService.syncAll'
	            }
	        },
	        saveStore : function()	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAll();					
				}else {
					alert(Msg.sMB083);
				}
	        },
	        loadStoreRecords: function(person_numb) {
     			var param= Ext.getCmp('searchForm').getValues();
     			param.PERSON_NUMB = person_numb;
				console.log( param );
    			this.load({
    				params: param
    			});
			}
		
		});
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '기본정보', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [
            	Unilite.popup('DOC',{
					fieldLabel: '입사서류',
					textFieldWidth:170,
					valueFieldName : 'DOC_ID',
					validateBlank:false
				}),{ 
    				fieldLabel: '입사일',
		        	xtype: 'uniDateRangefield',
		        	startFieldName: 'DVRY_DATE_FR',
		        	endFieldName: 'DVRY_DATE_TO',
		        	width: 470,
		        	startDate: "",
		        	endDate: "",
		        	
	        	}
			]
		}]
	});	//end panelSearch  
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('hbs810Grid', {
    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
		uniOpt: {
			expandLastColumn: false,
        	useRowNumberer: true,
            useMultipleSorting: true
        },
        columns: [        
        	{dataIndex: 'DEPT_NAME'		, width: 86}, 				
			{dataIndex: 'DEPT_CODE'		, width: 86, hidden: true}, 				
			{dataIndex: 'POST_CODE'		, width: 86}, 				
			{dataIndex: 'NAME'			, width: 86}, 				
			{dataIndex: 'PERSON_NUMB'	, width: 86}, 				
			{dataIndex: 'DATE'			, width: 86}				
		],
		listeners: {
		selectionchange: function(grid, selNodes ){
			if (typeof selNodes[0] != 'undefined') {
        	  console.log(selNodes[0].data.PERSON_NUMB);
        	  console.log(selNodes[0]);
        	  var person_numb = selNodes[0].data.PERSON_NUMB;
              directMasterStore2.loadStoreRecords(person_numb);
            console.log(person_numb);
			}
			
         }
       }
    });  
    
    var masterGrid2 = Unilite.createGrid('hbs810Grid2', {
    	layout : 'fit',
        region : 'east',
		store: directMasterStore2,
		uniOpt: {
			expandLastColumn: false,
        	useRowNumberer: true,
            useMultipleSorting: true
        },
        columns: [        
        	{dataIndex: 'CHK'				, width: 53,  xtype : 'checkcolumn'}, 				
        	{dataIndex: 'PERSON_NUMB'		, width: 100, hidden: true}, 				
			{dataIndex: 'DOC_TYPE'			, width: 100, hidden: true}, 				
			{dataIndex: 'DOC_ID'			, width: 66}, 				
			{dataIndex: 'DOC_NAME'			, width: 400}, 				
			{dataIndex: 'DOC_YYYY'			, width: 80, hidden: true}			
		] 
    }); 
    
	 Unilite.Main( {
		borderItems:[ 
			masterGrid,
			masterGrid2,
		 	panelSearch
		], 
		id : 'hbs810App',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			//UniAppManager.setToolbarButtons('save',true);
		},
		onQueryButtonDown : function()	{					
			masterGrid.getStore().loadStoreRecords();	
			masterGrid2.getStore().loadStoreRecords();
		},
		onSaveDataButtonDown: function() {
			//masterGrid2.getStore().syncAll();
			var selectedModel = directMasterStore2.getRange();
			var param = new Array(directMasterStore2.getCount);
			Ext.each(selectedModel, function(record, i) {
				data = new Object();
				console.log(record);
				data['CHK'] = record.data.CHK;
				data['PERSON_NUMB'] =record.data.PERSON_NUMB;
				data['DOC_TYPE'] = record.data.DOC_TYPE;
				data['DOC_ID'] = record.data.DOC_ID;
				data['DOC_NAME'] = record.data.DOC_NAME;
				data['DOC_YYYY'] = record.data.DOC_YYYY;
				data['S_USER_ID'] = "${loginVO.userID}";
				data['S_COMP_CODE'] = "${loginVO.compCode}";
				
				param[i] = data;
				
			});
			
			Ext.Ajax.request({
				url     : CPATH+'/human/hbs810ukrInsertDelete.do',
				params: {
					data: JSON.stringify(param)
				},
				success: function(response){	
					data = Ext.decode(response.responseText);
					console.log(data);
				    Ext.Msg.alert('확인', Msg.sMB011);
				    UniAppManager.setToolbarButtons('save',false);
				},
				failure: function(response){
					console.log(response);
					Ext.Msg.alert('확인', Msg.sMH899);
				}
			});	
		
			
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
