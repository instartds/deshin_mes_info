<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa740ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	var colData = ${colData};
	console.log(colData);
	
	var fields = createModelField(colData);
	var columns = createGridColumn(colData);
    var dateFlag  = true;
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 'hpa740ukrService.selectList',
            update  : 'hpa740ukrService.updateList',
            create  : 'hpa740ukrService.insertList',
            destroy : 'hpa740ukrService.deleteList',
            syncAll : 'hpa740ukrService.saveAll'
        }
    }); 
	
       
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hpa740ukrModel', {
		fields: fields
	});	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hpa740ukrMasterStore1', {
		model: 'hpa740ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		/*proxy: {
			type: 'direct',
			api: {			
				read: 'hpa740ukrService.selectList'
			}
		},*/
        proxy           :directProxy,
        
		loadStoreRecords: function(){
			var param= Ext.getCmp('resultForm').getValues();	
			param.DEPT_AUTH = UserInfo.deptAuthYn;
			console.log(param);
			this.load({
				params: param
			});
		},
		
        saveStore : function()  {
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            var list = [].concat( toUpdate );
            
//          var payYyyymm = panelSearch.getValue('PAY_YYYYMM');
//          var paramMaster = panelSearch.getValues();
//          paramMaster.PAY_YYYYMM = UniDate.getDbDateStr(payYyyymm).substring(0,6);
            
            console.log("list:", list);
            
            var rv = true;
            
            if(inValidRecs.length == 0 )    {
                config = {
//                  params: [paramMaster],
                    success: function(batch, option) {                              
                        panelResult.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false);         
                    } 
                };                  
                this.syncAllDirect(config);
                
            }else {
//              alert(Msg.sMB083);
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
		
		_onStoreLoad: function ( store, records, successful, eOpts ) {
	    	if(this.uniOpt.isMaster) {
	    		var recLength = 0;
	    		Ext.each(records, function(record, idx){
	    			
	    			recLength++;
	    			
	    		});
		    	if (records) {
			    	UniAppManager.setToolbarButtons('save', false);
					var msg = recLength + Msg.sMB001; //'건이 조회되었습니다.';
			    	UniAppManager.updateStatus(msg, true);	
		    	}
	    	}
	    }
		
	});

	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns :	2},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
			fieldLabel   : '지급년월',
            xtype       : 'uniMonthfield',
            value       : UniDate.get('today'),
            name        : 'PAY_YYYYMM',                    
            id          : 'PAY_YYYYMM',
            allowBlank  : false
        },{ 
        	fieldLabel: '사업장',
        	name: 'DIV_CODE',
        	xtype: 'uniCombobox', 
        	comboType:'BOR120'      	
    	},
		{
            fieldLabel: '부서',
            name: 'DEPTS2',
            xtype: 'uniCombobox',
            width:300,
            multiSelect: true,
            store:  Ext.data.StoreManager.lookup('authDeptsStore'),
            disabled:true,
            hidden:false,
            allowBlank:false
		},
		Unilite.treePopup('DEPTTREE',{
			itemId : 'deptstree',
			fieldLabel: '부서',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:150,
			validateBlank:true,
			width:400,
			autoPopup:true,
			useLike:true
		}),			
	     	Unilite.popup('Employee',{
			validateBlank: false
		}
		)]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('hpa740ukrGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        
        tbar: [
        {
            xtype:'button',
            text:'전월데이터 생성',
            handler:function()  {
               if (Ext.isEmpty(panelResult.getValue('PAY_YYYYMM')))
                       {alert('지급년월은 필수입력항목입니다.')}
                       else {
                               if(confirm('실행 하시겠습니까?')){
                                    runProc();
                                }  
                             }
            }
        }
        ],
    	/*viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(record.get('GUBUN') == '4'){
					cls = 'x-change-cell_dark';
				}
				else if(record.get('GUBUN') == '2' || record.get('GUBUN') == '3') {	//소계
					cls = 'x-change-cell_light';
				}
				return cls;
	        }
	    },*/
		store: directMasterStore1,
		selModel:'rowmodel',
		columns: columns,
        listeners: {
            beforeedit: function(editor, e){    
                if(UniUtils.indexOf(e.field, ['PERSON_NUMB', 'NAME' ,'SUPP_TYPE' ,'PAY_YYYYMM'])) {
                    if(e.record.phantom == true) {
                        return true;
                    }else{
                        return false;
                    }
                } 
            },                                                                                             
            edit: function(editor, e) {
                console.log(e);                                                    
                var fieldName = e.field;
                //var inputDate = e.value;
                //inputDate = inputDate.replace('.', '');
                
                
                
                if(fieldName == 'PAY_YYYYMM'){
                  var inputDate = e.value;
                  inputDate = inputDate.replace('.', '');
                    if(inputDate.length != 6 || isNaN(inputDate) || inputDate.substring(4,6) > 12){
                        if(dateFlag){
                            Ext.Msg.alert('확인', '날짜형식이 잘못되었습니다.');
                            e.record.set(fieldName, e.originalValue);
                            dateFlag = true;
                            return false;
                        }
                        dateFlag = true;
                        
                    }else{
                        var inputDate = e.value;
                        inputDate = inputDate.replace('.', '');
                        e.record.set(fieldName, inputDate.substring(0,4) + '.' + inputDate.substring(4,6));
                        dateFlag = false;
                    }
                }
            }
        }
	}); 
                                                 
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			id:'pageAll',
			items:[
				masterGrid, panelResult
			]
		}],
		id: 'hpa740ukrApp',
		fnInitBinding: function() {
			UniHuman.deptAuth(UserInfo.deptAuthYn, panelResult, "deptstree", "DEPTS2");

			panelResult.setValue('PAY_YYYYMM', UniDate.get('today'));
			panelResult.getField('PAY_YYYYMM').setReadOnly(false);
			
			UniAppManager.setToolbarButtons('reset',false);
            UniAppManager.setToolbarButtons('newData'   ,false);
           //UniAppManager.setToolbarButtons('save'      , false);            
            UniAppManager.setToolbarButtons('delete' ,false);
						
			masterGrid.on('edit', function(editor, e) {
				UniAppManager.setToolbarButtons('save',true);
			})
		},
		onQueryButtonDown: function() {			
			
            if(!panelResult.getInvalidMessage()) return;
            
			masterGrid.getStore().loadStoreRecords();
			
			panelResult.getField('PAY_YYYYMM').setReadOnly(true);//조회 버튼 클릭 시 기준 년도 버튼 readOnly true
			
            //버튼 세팅
            UniAppManager.setToolbarButtons('reset'     ,true);
            UniAppManager.setToolbarButtons('newData'   ,true);
            UniAppManager.setToolbarButtons('delete' ,true);
		},
        onNewDataButtonDown : function() {    
        	
        	var compCode = UserInfo.compCode
                /*var r = {
                    COMP_CODE : compCode
                }*/
                
            masterGrid.createRow({ 
                COMP_CODE : compCode,
               // PAY_YYYYMM : UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(0, 6),
                
                PAY_YYYYMM : UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(0,4) 
                            + '.' + UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(4,6),
                
                SUPP_TYPE : '1'
            });         
            
            var selectedRecord = masterGrid.getSelectedRecord();
            Ext.each(colData, function(item, index){
                 selectedRecord.set('CODE_'+item.WAGES_CODE, item.WAGES_CODE);
        });
            
            
            UniAppManager.setToolbarButtons('reset'     ,true);
            UniAppManager.setToolbarButtons('newData'   ,true);
            UniAppManager.setToolbarButtons('save'      ,true);            
            UniAppManager.setToolbarButtons('delete'    ,true);
        },
        
        onSaveDataButtonDown : function(){
            Ext.getCmp('hpa740ukrGrid1').getStore().syncAll();         
        },
        
        onDeleteDataButtonDown : function() {
            if(confirm(Msg.sMB062)) {
                masterGrid.deleteSelectedRow();
                UniAppManager.setToolbarButtons('save',true);   
            }
        },
        
        onResetButtonDown:function() {
            panelResult.clearForm();
            masterGrid.getStore().loadData({});

            this.fnInitBinding();
        }
	});
		
	// 모델 필드 생성
	function createModelField(colData) {
		
		var fields = [	{name: 'COMP_CODE',			text: '법인코드', 	editable:false,	   type: 'string' },
						{name: 'PAY_YYYYMM',		text: '지급년월', 	editable:true,	   type: 'string'},
						{name: 'DEPT_CODE',         text: '부서코드',     editable:true,     type: 'string' },
						{name: 'DEPT_NAME',         text: '부서명',      editable:true,     type: 'string' },
						{name: 'SUPP_TYPE',			text: '지급구분', 	editable:false,	   type: 'string' },
						{name: 'PERSON_NUMB',		text: '사번', 	    editable:true,	   type: 'string' },
						{name: 'NAME',              text: '이름',        editable:true,     type: 'string' }
												
					];
					
		Ext.each(colData, function(item, index){
			fields.push({name: 'CODE_'  + item.WAGES_CODE, text:'CODE_' + item.WAGES_CODE, editable:false, type:'string' });
			fields.push({name: 'WAGES_' + item.WAGES_CODE, text:item.WAGES_NAME, editable:true, type:'uniPrice' });
		});
		
		
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		
		var columns = [
			{dataIndex: 'COMP_CODE',		 width: 100, hidden: true},
			{dataIndex: 'PAY_YYYYMM',		 width: 100, align: 'center'},
			{dataIndex: 'DEPT_CODE',         width: 80
			,   editor:Unilite.popup('DEPT_G',{
                textFieldName:'DEPT_CODE',
                DBtextFieldName: 'TREE_CODE',
                validateBlank : true,
                autoPopup: true,
                listeners:{
                    scope:this,
                    onSelected:{
                        fn:function(records, type){
                            var rtnRecord = masterGrid.uniOpt.currentRecord; 
                            rtnRecord.set('DEPT_CODE', records[0]["TREE_CODE"]);
                            rtnRecord.set('DEPT_NAME', records[0]["TREE_NAME"]);                          
                        } 
                    },
                    onClear:function(type)  {
                        var rtnRecord = masterGrid.uniOpt.currentRecord; 
                            
                        rtnRecord.set('DEPT_CODE', '');
                        rtnRecord.set('DEPT_NAME', '');
                    }
                }
            }) 
			
			},
			{dataIndex: 'DEPT_NAME',         width: 120
			,   editor:Unilite.popup('DEPT_G',{
                textFieldName:'DEPT_CODE',
                DBtextFieldName: 'TREE_CODE',
                validateBlank : true,
                autoPopup: true,
                listeners:{
                    scope:this,
                    onSelected:{
                        fn:function(records, type){
                            var rtnRecord = masterGrid.uniOpt.currentRecord; 
                            rtnRecord.set('DEPT_CODE', records[0]["TREE_CODE"]);
                            rtnRecord.set('DEPT_NAME', records[0]["TREE_NAME"]);                          
                        } 
                    },
                    onClear:function(type)  {
                        var rtnRecord = masterGrid.uniOpt.currentRecord; 
                            
                        rtnRecord.set('DEPT_CODE', '');
                        rtnRecord.set('DEPT_NAME', '');
                    }
                }
            }) 
			
			},
			{dataIndex: 'SUPP_TYPE',		 width: 80, hidden: true},
			{dataIndex: 'PERSON_NUMB',	  	 width: 100
			,  'editor' : Unilite.popup('Employee_G',{
                validateBlank : true,
                autoPopup:true,
                listeners: {
                    'onSelected': {
                        fn: function(records, type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);   //사번
                            grdRecord.set('NAME', records[0].NAME);                 //성명                                    
                        },
                        scope: this
                    },
                    'onClear': function(type) {
                        var grdRecord = masterGrid.uniOpt.currentRecord;
                        grdRecord.set('PERSON_NUMB','');
                        grdRecord.set('NAME','');
                    },
                    applyextparam: function(popup){ 
                    }
                }
            })
			
			},
			{dataIndex: 'NAME',              width: 100
			,  'editor' : Unilite.popup('Employee_G',{
                validateBlank : true,
                autoPopup:true,
                listeners: {
                    'onSelected': {
                        fn: function(records, type) {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);   //사번
                            grdRecord.set('NAME', records[0].NAME);                 //성명                                    
                        },
                        scope: this
                    },
                    'onClear': function(type) {
                        var grdRecord = masterGrid.uniOpt.currentRecord;
                        grdRecord.set('PERSON_NUMB','');
                        grdRecord.set('NAME','');
                    },
                    applyextparam: function(popup){ 
                    }
                }
            })
			}
		]
					
		Ext.each(colData, function(item, index){
			columns.push({dataIndex: 'CODE_'  + item.WAGES_CODE, width:100, hidden: true});
			columns.push({dataIndex: 'WAGES_' + item.WAGES_CODE, width:100});
			
		});
		console.log(columns);
		return columns;
	}
	
	    //데이터 일괄생성
    function runProc() {     
        //Ext.getCmp('pageAll').getEl().mask('생성중...');    // mask on
        var param= Ext.getCmp('resultForm').getValues();
        param.RE_TRY = "";

        /*panelSearch.getEl().mask('급여계산 중...','loading-indicator');*/
        hpa740ukrService.procSP(param, function(provider, response)  {
            console.log("response", response);
            console.log("provider", provider);
            
            if(!Ext.isEmpty(provider)){
                if(provider.ERROR_CODE == "Y")  {
                    if(confirm(' 해당지급년월에 데이터가 존재합니다. \n 기존데이터를 삭제하시고 \n 새로운 데이터를 생성하시겠습니까?')){
                        reRunProc();
                    }else{
                        
                        Ext.getCmp('pageAll').getEl().unmask(); 
                    }//급여작업이 완료되었습니다.
                } else if(provider.ERROR_CODE == "") {
                    UniAppManager.app.onQueryButtonDown(); 
                    
                    Ext.getCmp('pageAll').getEl().unmask();
                }
            }
            
        }); 
    }
    
      //데이터 일괄생성
    function reRunProc() {        
        var param= Ext.getCmp('resultForm').getValues();
        param.RE_TRY = "Y";

        hpa740ukrService.procSP(param, function(provider, response)  {
            console.log("response", response);
            console.log("provider", provider);
            if(!Ext.isEmpty(provider)){
            	
                if(provider.ERROR_CODE == "")  {
                    alert("생성이 완료되었습니다."); 

                    UniAppManager.app.onQueryButtonDown();
                    
                    Ext.getCmp('pageAll').getEl().unmask();
                } 
            }
                              
        }); 
    }
		
};


</script>