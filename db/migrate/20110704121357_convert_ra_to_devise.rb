class ConvertRaToDevise < ActiveRecord::Migration
  def self.up
    #encrypting passwords and authentication related fields
    rename_column :users, "crypted_password", "encrypted_password"
    change_column :users, "encrypted_password", :string, :limit => 128, :default => "", :null => false
    rename_column :users, "salt", "password_salt"
    change_column :users, "password_salt", :string, :default => "", :null => false
    
    #rememberme related fields
    add_column :users, "remember_created_at", :datetime #additional field required for devise.
  end

  def self.down
    #rememberme related fields
    remove_column :users, "remember_created_at"
    
    #encrypting passwords and authentication related fields
    rename_column :users, "encrypted_password", "crypted_password"
    change_column :users, "crypted_password", :string, :limit => 40
    rename_column :users, "password_salt", "salt" 
    change_column :users, "salt", :string, :limit => 40
  end
end
