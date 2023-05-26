<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat600ukr_kd"  >
	<t:ExtComboStore comboType="BOR120" pgmId="hat520skr"  /> 		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /><!--  급여지급일구분   -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /><!--  급여지급방식   -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /><!--  사원구분   -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /><!--  사원그룹   --> 
</t:appConfig>
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

ext-el-mask { color:gray; cursor:default; opacity:0.6; background-color:grey; }

.ext-el-mask-msg div {
	background-color: #EEEEEE;
	border-color: #A3BAD9;
	color: #222222;	
}

.ext-el-mask-msg {
	padding: 10px;
}   
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */
/*
	Unilite.defineModel('s_hat600ukr_kdModel', {		
	    fields: [{name: 'WORK_TYPE' 		,text: '작업항목'	,type: 'string'},			  
				 {name: 'WORK_START_TIME'	,text: '시작시간'	,type: 'string'},			  
				 {name: 'WORK_END_TIME'		,text: '종료시간'	,type: 'string'},
				 {name: 'WORK_TOTAL_TIME'	,text: '작업시간'	,type: 'string'},
				 {name: 'WORK_CONTENT'		,text: '작업내용'	,type: 'string'},			  
				 {name: 'WORK_REMARK'		,text: '비고' 	,type: 'string'}
			]
	});
	*//**
	 * Store 정의(Service 정의)
	 * @type 
	 *//*					
	var directMasterStore1 = Unilite.createStore('s_hat600ukr_kdMasterStore1',{
			model: 's_hat600ukr_kdModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 's_hat600ukr_kdService.doTotalWork'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});				
			}
			
	});*/
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    
    var panelSearch = Unilite.createForm('searchForm', {		
		disabled :false
    ,	flex:1        
    ,	layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}}
	,	items: [{
			fieldLabel: '지급차수',
			name: 'PAY_PROV_FLAG', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H031',
			allowBlank:false,				
			listeners: {
	            blur: {
	            	fn:function() {
	            		payProvDate();
	            	}
	            }
			}
		},{
			fieldLabel: '근태년월',
			id: 'frToDate',
			xtype: 'uniMonthfield',
			name: 'DUTY_YYYYMM',
// 				xtype: 'uniDatefield',
// 				name: 'FR_DATE',                    
			value: new Date(),                    
			allowBlank: false,				
			listeners: {
	            blur: {
	            	fn:function() {
	            		payProvDate();
	            	}
	            }
			}
		},{ 
			fieldLabel: '근태집계기간',
        	xtype: 'uniDateRangefield',
        	startFieldName: 'DUTY_YYYYMMDD_FR',
        	endFieldName: 'DUTY_YYYYMMDD_TO',
        	width: 325,
//        	startDate: UniDate.get('startOfMonth'),
//        	endDate: UniDate.get('today'),
        	allowBlank: false
        },{ 
			fieldLabel: '급여집계기간',
        	xtype: 'uniDateRangefield',
        	startFieldName: 'PAY_YYYYMMDD_FR',
        	endFieldName: 'PAY_YYYYMMDD_TO',
        	width: 325,
//        	startDate: UniDate.get('startOfMonth'),
//        	endDate: UniDate.get('today'),
        	allowBlank: false
        },{
			fieldLabel: '사업장',
			name: 'DIV_CODE',
			id: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120'
		},
		Unilite.popup('DEPT', { 
			fieldLabel		: '부서', 
			valueFieldName	: 'DEPT_CODE',
			textFieldName	: 'DEPT_NAME',
			holdable		: 'hold',
			listeners		: {
//		    	onValueFieldChange: function(field, newValue){
//					panelResult.setValue('DEPT_CODE', newValue);	
//				},
//				onTextFieldChange: function(field, newValue){
//					panelResult.setValue('DEPT_NAME', newValue);	
//				}
			}
		})/*,
		Unilite.treePopup('DEPTTREE',{
			fieldLabel: '부서',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			autoPopup:true,
			useLike:true,
			listeners: {
//                'onValueFieldChange': function(field, newValue, oldValue  ){
//                    	panelResult.setValue('DEPT',newValue);
//                },
//                'onTextFieldChange':  function( field, newValue, oldValue  ){
//                    	panelResult.setValue('DEPT_NAME',newValue);
//                },
//                'onValuesChange':  function( field, records){
//                    	var tagfield = panelResult.getField('DEPTS') ;
//                    	tagfield.setStoreData(records)
//                }
			}
		})*/,{
			fieldLabel: '급여지급방식',
			name:'PAY_CODE',	
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'H028'
		},{
			fieldLabel: '사원구분',
			name:'EMPLOY_GB',	
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'H024'
		},{
			fieldLabel: '사원그룹',
			name:'PERSON_GB',	
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'H181'
		},			
	     	Unilite.popup('Employee',{ 
			
			validateBlank: false,
			listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//	                	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('PERSON_NUMB', '');
//						panelResult.setValue('NAME', '');
//					}
//				onValueFieldChange: function(field, newValue){
//					panelResult.setValue('PERSON_NUMB', newValue);								
//				},
//				onTextFieldChange: function(field, newValue){
//					panelResult.setValue('NAME', newValue);				
//				}
			}
		}),{
	    	xtype: 'container',
	    	padding: '10 0 0 0',
	    	layout: {
	    		type: 'vbox',
				align: 'center',
				pack:'center'
	    	},
	    	items:[{
	    		xtype: 'button',
	    		text: '실행',
	    		width: 100,
				margin: '0 0 5 100',
	    		handler: function(){
	    			if(!panelSearch.getInvalidMessage()){
						return false;
					}
					var param = panelSearch.getValues();
					Ext.getBody().mask('로딩중...','loading-indicator');
					s_hat600ukr_kdService.insertMaster(param, function(provider, response)	{						
						if(provider){
							UniAppManager.updateStatus(Msg.sMB011);
						}
						Ext.getBody().unmask();
					});	
					
	    		}
	    	}]
	    }]
	});
		
	// 근태, 급여 집계기간을 설정함
	function payProvDate(data, event) {
		var param = panelSearch.getValues();
//		param.DUTY_YYYYMM = 
		s_hat600ukr_kdService.getPayProvDate(param, function(provider, response){
			if(!Ext.isEmpty(provider)){
				panelSearch.setValue('DUTY_YYYYMMDD_FR', provider.STRT_DT);
				panelSearch.setValue('DUTY_YYYYMMDD_TO', provider.END_DT);
				panelSearch.setValue('PAY_YYYYMMDD_FR', provider.PAY_STRT_DT);
				panelSearch.setValue('PAY_YYYYMMDD_TO', provider.PAY_END_DT);
			}
		});
		
	}
    /*
	// 집계가 이루어지는 함수
    function doTotalWork() {
		var param= Ext.getCmp('searchForm').getValues();
		param.S_USER_ID = "${loginVO.userID}";
		param.ISEXTENDED = 'Y';
// 		param.ERR_DESC = '';		
		console.log(param);
		
		Ext.Ajax.on("beforerequest", function(){
			Ext.getBody().mask('로딩중...', 'loading')
	    }, Ext.getBody());
		Ext.Ajax.on("requestcomplete", Ext.getBody().unmask, Ext.getBody());
		Ext.Ajax.on("requestexception", Ext.getBody().unmask, Ext.getBody());
		
		Ext.Ajax.request({
			url     : CPATH+'/human/doTotalWorks_hat600ukr_kd.do',
			params: param,
			success: function(response){
				data = Ext.decode(response.responseText);
				console.log(data);
				Ext.Msg.alert('완료',data);
			},
			failure: function(response){
				console.log(response);
				Ext.Msg.alert('실패', response.statusText);
			}
		});
    }
    */
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
   /* var masterGrid = Unilite.createGrid('s_hat600ukr_kdGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: directMasterStore1,
    	uniOpt:{	useRowNumberer: true,
                    useMultipleSorting: true
        },
        columns:  [{ dataIndex:	'WORK_TYPE' 		, width: 100},
        		   { dataIndex:	'WORK_START_TIME'	, width: 170},
        		   { dataIndex:	'WORK_END_TIME'		, width: 170},
        		   { dataIndex:	'WORK_TOTAL_TIME'	, width: 170},
        		   { dataIndex:	'WORK_CONTENT'		, width: 250},
        		   { dataIndex:	'WORK_REMARK'		, width: 250}        		   
        ] 
    });   */
	
    Unilite.Main( {
		items:[panelSearch],
		id  : 's_hat600ukr_kdApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);
			panelSearch.onLoadSelectText('PAY_PROV_FLAG');
		}
	});
};


</script>
	