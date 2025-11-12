module UploadHelper
  def save_uploaded_image(uploaded_file, folder: "uploads")
    return nil unless uploaded_file.present?

    filename = "#{SecureRandom.hex(8)}_#{sanitize_filename(uploaded_file.original_filename)}"
    directory = Rails.root.join("public", folder)
    FileUtils.mkdir_p(directory)

    filepath = directory.join(filename)
    File.open(filepath, "wb") { |f| f.write(uploaded_file.read) }

    "/#{folder}/#{filename}"
  end

  private

  def sanitize_filename(filename)
    return unless filename
    filename.gsub(/[^\w.\-]/, "_")
  end
end
