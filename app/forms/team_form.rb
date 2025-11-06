class TeamForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :id, :name, :description

  validates :name, presence: { message: "Không được để trống" }
  validate :name_must_be_unique

  private

  def name_must_be_unique
    # Bỏ qua bản ghi hiện tại nếu đang edit
    if Team.where.not(id: id).exists?(name: name)
      errors.add(:name, "Dữ liệu đã tồn tại, vui lòng chọn tên khác")
    end
  end
end
