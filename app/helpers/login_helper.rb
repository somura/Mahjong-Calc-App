# Login Helper
module LoginHelper
  def create_login_session(data)
    cipher = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
    cipher.encrypt
    cipher.pkcs5_keyivgen('password')
    cipher.update(data) + cipher.final
  end

  def decrypt_login_session(data)
    cipher = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    cipher.decrypt
    cipher.pkcs5_keyivgen('password')
    cipher.update(data) + cipher.final
  end
end
