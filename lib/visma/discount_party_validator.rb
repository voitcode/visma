# frozen_string_literal: true

# Validate the DiscountAgreementCustomer discount party.
class DiscountPartyValidator < ActiveModel::Validator
  def validate(record)
    return true if record.discounted_party

    record.errors[:customer] << 'Discounted party is not defined'
    record.errors[:price_list] << 'Discounted party is not defined'
    record.errors[:discount_group_customer] << 'Discounted party is not defined'
  end
end
