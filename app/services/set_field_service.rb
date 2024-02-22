class SetFieldService
  def call(customer:, field_name:, new_value:)
    ActiveRecord::Base.transaction do
      case field_name
      when 'email'
        return { error: 'You need to specify an email for this customer.' } if new_value.blank?

        new_value = new_value.strip.downcase

        return { error: "Can't save email. Invalid value: '#{new_value}'" } if EmailValidator.valid?(new_value) != true

        customer.email = new_value
        customer.verified = 0

        begin
          customer.save!
        rescue ActiveRecord::RecordNotUnique
          return { error: 'Email already exists.' }
        rescue StandardError => e
          return { error: e.to_s }
        end
        return {}

      when 'first_name'
        customer.first_name = new_value.strip
      when 'last_name'
        customer.last_name = new_value.strip
      when 'phone'
        customer.phone = new_value.strip
      when 'title'
        customer.title = new_value.strip
      when 'role'
        customer.role = new_value.strip
      when 'score'
        customer.score = new_value.to_i
      else
        return { error: "Unknown field: '#{field_name}'" }
      end
      customer.save!

      return {}
    end
  end
end
