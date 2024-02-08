# frozen_string_literal: true

class ClientsController < ApplicationController
  def index
    scope = Client
    scope = scope.where("name LIKE :q OR email LIKE :q", q: "%#{params[:q].presence}%") if params[:q].present?
    @clients = scope.limit(10)
    render layout: nil
  end
end
