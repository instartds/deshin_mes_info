/**************************************************
 * Common variable
 **************************************************/

/**************************************************
 * Common Code
 **************************************************/
	
/**************************************************
 * Model
 **************************************************/

/**************************************************
 * Store
 **************************************************/

/**************************************************
 * Define
 **************************************************/
Ext.define('nbox.docEditContentsHtmlEditor', {
	extend: 'Ext.form.HtmlEditor',
	name: 'Contents'
});
/*
Ext.define('nbox.docEditContentsHtmlEditor',{
	extend: 'Ext.view.View',
	config: {
		regItems: {}
	},
	
	name: 'Contents',
	loadMask:false,
    cls: 'nbox-feed-list',
    itemSelector: '.nbox-feed-sel-item',
    selectedItemCls: 'nbox-feed-seled-item', 
    width: docControlPanelWidth - 27,
	initComponent: function () {
		var me = this;
		
		me.tpl = new Ext.XTemplate(
			'<div id="smart_editor2">',
				'<div id="smart_editor2_content"><a href="#se2_iframe" class="blind">글쓰기영역으로 바로가기</a>',
					'<div class="se2_tool" id="se2_tool">',
					'</div>',
					'<div class="se2_layer se2_accessibility" style="display:none;">',
					'</div>',
					'<div class="se2_input_area husky_seditor_editing_area_container">',
						'<iframe src="about:blank" id="se2_iframe" name="se2_iframe" class="se2_input_wysiwyg" width="400" height="300" title="글쓰기 영역 : 도구 모음은 ALT+F10을, 도움말은 ALT+0을 누르세요." frameborder="0" style="display:block;"></iframe>',
						'<textarea name="" rows="10" cols="100" title="HTML 편집 모드" class="se2_input_syntax se2_input_htmlsrc" style="display:none;outline-style:none;resize:none"> </textarea>',
						'<textarea name="" rows="10" cols="100" title="TEXT 편집 모드" class="se2_input_syntax se2_input_text" style="display:none;outline-style:none;resize:none;"> </textarea>',
					'</div>',
					'<div class="se2_conversion_mode">',
						'<ul class="se2_converter">',
							'<li class="active"><button type="button" class="se2_to_editor"><span>Editor</span></button></li>',
							'<li><button type="button" class="se2_to_html"><span>HTML</span></button></li>',
							'<li><button type="button" class="se2_to_text"><span>TEXT</span></button></li>',
						'</ul>',
					'</div>',
				'</div>',
	       	'</div>'
		); 
		
		me.callParent();
	}
});
*/
Ext.define('nbox.docEditContentsPanel', { 
	extend: 'Ext.panel.Panel',

	config: {
		store:null,
		regItems: {}
    },
    
    layout: {
		type: 'fit'
	},
	
	flex: 1,
	
	style: {
		'margin': '5px 5px 5px 5px'
   	},
	
	border: false,
	
	initComponent: function () {
		var me = this;
		
		var docEditContentsHtmlEditor =  Ext.create('nbox.ckeditor.ckeditor', {
	        fieldLabel: '', 
	        name:'nboxCkeditor',
	        CKConfig: { 
	            /* Enter your CKEditor config paramaters here or define a custom CKEditor config file. */
	            customConfig : 'config.js',
    	        qtRows: 20, // Count of rows
    	        qtColumns: 20, // Count of columns
    	        qtBorder: '1', // Border of inserted table
    	        qtWidth: '600px', // Width of inserted table
    	        qtStyle: { 'border-collapse' : 'collapse' },
    	        qtCellPadding: '3px', // Cell padding table
    	        qtCellSpacing: '0' // Cell spacing table
    	        
	        }
	    });  
		
		me.items = [docEditContentsHtmlEditor];
		
		me.callParent();
	},
	queryData: function(){

	},
	clearData: function(){
		var me = this;
		
		//me.removeAll();
	},
	loadPanel: function(){
    	var me = this;
    	var docEditContentsHtmlEditor = me.items.items[0];
    	var nboxDocEditPanel = Ext.getCmp('nboxDocEditPanel');
    	var editPanelStore = null
    	
    	if (docEditContentsHtmlEditor.name == "nboxCkeditor" )
    	{
	    	if (nboxDocEditPanel)
	   		{
	    		editPanelStore = nboxDocEditPanel.getStore();
	   		}
	    	
	    	if (editPanelStore)
			{
	    		if (editPanelStore.getCount() > 0)
				{
	    			if (docEditContentsHtmlEditor)
					{
	    				if (docEditContentsHtmlEditor.InstanceReadyFlag)
	    					docEditContentsHtmlEditor.setValue(editPanelStore.getAt(0).get('Contents'));
                        else
                            docEditContentsHtmlEditor.tempData = editPanelStore.getAt(0).get('Contents');
	    				
					}
				}
			}
    	}
	}
});
/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	