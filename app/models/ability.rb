class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    user.role.permissions.each do |permission|
      if permission.subject_class == "all"
        can permission.action.to_sym, permission.subject_class.to_sym
      else
        klass_name = permission.subject_class.constantize rescue permission.subject_class.downcase.to_sym
        can permission.action.to_sym, klass_name
      end
    end
  end
end
