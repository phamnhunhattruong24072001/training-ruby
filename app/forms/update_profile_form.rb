class UpdateProfileForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :fullname, :display_name, :phone, :birth_day

  validates :fullname, presence: { message: "Không được để trống" }
  validates :display_name, presence: { message: "Không được để trống" }
  validates :phone, format: {
    with: /\A\d{9,11}\z/,
    message: "Phải là số và có từ 9 đến 11 chữ số"
  }, allow_blank: true
  validate :birth_day_cannot_be_in_future

  private

  def birth_day_cannot_be_in_future
    return if birth_day.blank?

    begin
      date = Date.parse(birth_day.to_s)
      if date > Date.today
        errors.add(:birth_day, "Không được lớn hơn ngày hiện tại")
      end
    rescue ArgumentError
      errors.add(:birth_day, "Không hợp lệ")
    end
  end
end
