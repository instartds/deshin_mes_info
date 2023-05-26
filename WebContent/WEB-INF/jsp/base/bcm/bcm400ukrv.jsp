<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="bcm400ukrv"  >

	<t:ExtComboStore comboType="BOR120" /> 			<!-- 사업장 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('bcm400ukrvModel', {		
	    fields: [{name: ''		 	,text: '' 			,type: ''}	
			
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('bcm400ukrvMasterStore1',{
			model: 'bcm400ukrvModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'bcm400ukrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			groupField: 'CUSTOM_NAME'			
	});
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */    
	var detailForm = Unilite.createForm('bcm400ukrvDetail', {
		disabled :false,
		flex:1,        
		layout: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
		defaults:{labelWidth: 100},
		items :[{
			xtype:'container',
			html: '<b>홈텍스 전자신고 파일 암호화 변환</b>',
			style: {
				color: 'blue'				
				}
		},{ 
			fieldLabel: '비밀번호 ',
			xtype: 'uniTextfield',
			name: '',
		 	allowBlank:false
		}, { 
			fieldLabel: '비밀번호 확인',
	        xtype: 'uniTextfield',
	        name: '',
		 	allowBlank:false
        },{ 
			fieldLabel: '홈텍스 파일선택',
	        xtype: 'uniTextfield',
	        name: ''
        },{
			xtype:'container',
			html: '※ 변환 순서'
		},{
			xtype:'container',
			html: '1. 암호화할 파일의 비밀번호를 입력합니다.'

		},{
			xtype:'container',
			html: '2. 찾아보기를 클릭하여 암호화변환을 할 전자신고 파일을 선택후 <b>파일변환</b> 버튼을 클릭합니다.'
		},{
			xtype:'container',
			html: '3. 파일변환후 "저장하시겠습니까?" 메세지가 뜨면 "<b>저장</b>"버튼을 클릭하여 암호화된 파일을 저장합니다.'
		}
        ]	         
		         
	});
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('bcm400ukrvGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: directMasterStore1,
    	uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
               		 { dataIndex:''		 	, 	width:80,  locked:true}				

        ]                        		  	
    });   		
    Unilite.Main( {
		items:[ 
	 		 detailForm
		],
		id  : 'bcm400ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			
				masterGrid1.getStore().loadStoreRecords();
				var viewLocked = masterGrid1.lockedGrid.getView();
				var viewNormal = masterGrid1.normalGrid.getView();
				console.log("viewLocked : ",viewLocked);
				console.log("viewNormal : ",viewNormal);
			    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);				
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
