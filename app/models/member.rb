class Member < ApplicationRecord
  # Destroying a Member record must remove all associated records too
  has_many :votes, dependent: :destroy
  has_one_attached :image

  # 'image_url' may not exist for a Member
  validates_presence_of :name, :title, :bio

  # Active and Inactive Member records can be fetched using
  # Member.unscoped
  default_scope { where(active: true).order(:id) }

  # Attach image file only after a Member record is saved into DB
  after_commit on: :create do
    AttachImageJob.enqueue(id) if image_url.present? && image.blank?
  end

  # Deactivate 'terminated' members
  def self.deactivate_residue_by(ids)
    Member.where.not(id: ids).update_all(active: false)
  end
end
