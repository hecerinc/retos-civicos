class CommentsController < ApplicationController

	def create
		@challenge = Challenge.find(params[:challenge_id])
		@comment = Comment.build_from(@challenge, current_user.id, params[:comment][:body])
		if @comment.save
			redirect_to challenge_path(@challenge, anchor: 'comments'), notice: t('comments.commented')
		else
			redirect_to challenge_path(@challenge, anchor: 'comments'), error: t('comments.failure')
		end
	end

	def like
		@comment = Comment.find(params[:id])
		@challenge = Challenge.find(params[:challenge_id])
		if params[:like].present?
    	current_user.vote_for(@comment)
    else
    	current_user.vote_against(@comment)
    end
    @comment.update_votes_counter
    redirect_to @challenge, notice: t('comments.voted')
	end

	def reply
		@challenge = Challenge.find(params[:challenge_id])
		@reply = Comment.build_from(@challenge, current_user.id, params[:comment][:body])
		parent_comment = Comment.find(params[:parent])
		if @reply.save
			@reply.move_to_child_of(parent_comment)
			redirect_to challenge_path(@challenge, anchor: 'comments'), notice: t('comments.commented')
		else
			redirect_to challenge_path(@challenge, anchor: 'comments'), error: t('comments.failure')
		end
	end

end
