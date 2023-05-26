<%@page language="java" contentType="text/html; charset=utf-8"%>
<script type="text/javascript" >
/* 
* SWFUpload adapter for Ext
 * Author: Chris Alfano (chris@devnuts.com) - Sep 06,2009
 * Author: Henry Paradiz (henry@devnuts.com) - June 17, 2011 - Upgraded to Ext 4
 * 
 * See SWFUpload documentation: http://demo.swfupload.org/Documentation/#settingsobject
 */
 
 // REQUIRES THIS EXTERNAL FILE:     //name: 'SWFUpload'
    //,URL: '/jslib/SWFUpload/swfupload.js' // need to figure out how to dynamically load this with Extjs4
 

        
        var backUploaderSWF = Ext.create('Ext.ux.SWFUpload', {
            renderTo: Ext.getBody()
            ,config: {
                autoStart: true
                ,debugMode: false
                ,targetUrl: '/artwork/json/upload'
                ,fieldName: 'Back'
                ,file_size_limit: "50 MB"
                ,file_types: '*'
                ,file_types_description: 'Back T-Shirt Artwork'    
                ,button_width: 158
                ,button_height: 55
                ,button_image_url: CPATH+'/resources/images/t1.png'
                ,button_action: SWFUpload.BUTTON_ACTION.SELECT_FILE
            }
            ,listeners: {
                scope: this
                ,ready: function() {
                    //this.onReady('back');
                } // ready
                
                ,uploadComplete: function(file) {  //finish
                   
                } // uploadComplete
                ,uploadError: function(file, errorCode, errorMessage) { //error
                    console.info(file,errorCode, errorMessage);
                    this.frontArtworkUploading  = false;
                } // uploadError
                
            }//listeners
            , updateFrontArtwork  : function() {
            	console.log('done');
            }
        }
     );
</script>