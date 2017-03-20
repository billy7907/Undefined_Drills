class Group < ApplicationRecord

  has_many :drills, dependent: :destroy
  has_many :user_groups, dependent: :destroy
  has_many :bookmarkers, through: :user_groups, source: :user

  # VALIDATIONS
  validates :title, presence: true, uniqueness: true

  def child_total(user, groups)
    Drill.where(:group_id => groups).all
  end


  def bookmarked_by?(user, groups)
    if (UserGroup.exists?(:user => user) && UserGroup.exists?(:group => groups.id))
      return true
    else
      return false
    end
  end

  def bookmark_for(user)
    UserGroup.find_by(user_id: user)
  end

end
