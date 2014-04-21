class Account < ActiveRecord::Base
  include AccountsHelper 
  validates :username, length: {maximum: 15}, uniqueness: { case_sensitive: false}
  
  before_save do |account|
    success = true
    begin
      account.corpus = AccountsHelper::get_all_tweets(account.username)
    rescue Twitter::Error => e
      puts e.message
      account.errors.add(:corpus, "Error querying Twitter API: " << e.message)
      success = false
    end
    success
  end
end
