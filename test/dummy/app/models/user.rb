# frozen_string_literal: true

class User
  include Databaseless

  def address
    @address ||= Address.new
  end

  def roles
    @roles ||= Role.new
  end

  def address_attributes=(attributes)
    address.attributes.merge! attributes
  end
end
