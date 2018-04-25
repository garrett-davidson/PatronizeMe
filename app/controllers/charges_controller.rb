# app/controllers/charges_controller.rb

class ChargesController < ApplicationController
  def new
  end

  def withdraw
      funds = current_user.balance
      logger.debug funds
      current_user.balance = 0
      current_user.save
  end


  def create
    # Amount in cents
    @params = params
    @amount = params[:amt]
    logger.debug @amount
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )

    current_user.balance += @amount.to_i
    current_user.save!

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

end
