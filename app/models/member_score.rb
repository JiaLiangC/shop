class MemberScore < ApplicationRecord

	belongs_to :user
	after_save :update_user_score


	private

		def update_user_scores
			user = self.user
			if user.present?
				ActiveRecord::Base.transaction do
					user.lock!
					new_scores = user.member_scores.sum(:num)
					user.update_attributes!(scores: new_scores) if new_scores > 0
				end
			end
		end
end
