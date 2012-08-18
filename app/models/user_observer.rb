class UserObserver < ActiveRecord::Observer
  
  # 1. Send the new user a welcome email
  # 2. Notify all administrators when a new user registers added.  
  def after_commit(record)
    # 1
    Email.welcome(record).deliver
    
    # 2
    User.where(:admin => true, :admin_notifications => true).each do |admin|
      Email.user_registration(admin, record).deliver
    end
  end

  # Notify all administrators when a new conference number is deleted.
  def after_destroy(record)
    User.where(:admin => true, :admin_notifications => true).each do |admin|
      Email.user_deleted(admin, record, record.audits.last.user_id).deliver
    end
  end
  
end