# app/controllers/charges_controller.rb

class ChargesController < ApplicationController
  def new
  end

  def withdraw

    /testSource = Stripe::Source.create(
      :type => "ach_debit",
      :currency => 'usd',
      :owner => {
        :email => 'jenny.rosen@example.com',
      },
    )
    customer = Stripe::Customer.create(
      :email => 'jenny.rosen@example.com',
      :source  => testSource
    )/
  end


  def create
    # Amount in cents
    @params = params
    @amount = params[:amt]

   

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