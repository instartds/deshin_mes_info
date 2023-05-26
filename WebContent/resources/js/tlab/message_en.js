
var globalMessage = {
	confirm_insert: 'Do you want to register this?',
	confirm_update: 'Do you want to modify this?',
	confirm_deletion: 'Do you want to delete this?',
	confirm_move: 'Do you want to move this?',
	
	noData: 'No data was found.',
	inserted: 'It has been registered.',
	updated: 'It has been modified.',
	deleted: 'It has been deleted.',
	completed: 'It has benn completed.',
	
	/**
	 * "데이터가 없습니다." 메세지
	 */
	noDataMessage: function() {
		this.stop();
		alert(this.noData);		
	},
	
	/**
	 * "입력되었습니다" 메세지
	 */
	insertedMessage: function() {
		this.stop();
		alert(this.inserted);
	},
	
	/**
	 * "수정되었습니다" 메세지
	 */
	updatedMessage: function() {
		this.stop();
		alert(this.updated);
	},
	
	/**
	 * "삭제되었습니다" 메세지
	 */
	deletedMessage: function() {
		this.stop();
		alert(this.deleted);
	},
	
	/**
	 * "완료되었습니다" 메세지
	 */
	completedMessage: function() {
		this.stop();
		alert(this.completed);
	},
	
	stop: function() {
		$('#spinnerElement').hide();
	}
};