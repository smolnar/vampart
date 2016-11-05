Paperclip::Attachment.default_options.update({
  url: '/uploads/:class/:attachment/:id_partition/:style/:hash.:extension',
  hash_secret: Rails.application.secrets.secret_key_base
})
