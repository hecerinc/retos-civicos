# encoding: utf-8

class UserAvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :profile do
    process resize_to_fit: [200, 200]
  end

  version :small do
    process resize_to_fit: [80, 80]
  end

  version :thumb do
    process resize_to_fit: [60, 60]
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def store_dir
    "uploads/user_avatar/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
