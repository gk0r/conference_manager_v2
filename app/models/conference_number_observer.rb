class ConferenceNumberObserver < ActiveRecord::Observer
  
  # Notify all administrators when a new conference number is added.  
  def after_commit (record)
    User.where(:admin => true, :admin_notifications => true).each do |admin|
      Email.conference_number_added(admin, record, record.audits.last.user_id).deliver
    end
  end

  # Notify all administrators when a new conference number is deleted.
  def after_destroy (record)
    User.where(:admin => true, :admin_notifications => true).each do |admin|
      Email.conference_number_deleted(admin, record, record.audits.last.user_id).deliver
    end
  end
  
end