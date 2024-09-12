# app/mailers/alert_mailer.rb
class AlertMailer < ApplicationMailer
  def price_alert(alert)
    @alert = alert
    mail(to: @alert.user.email, subject: 'Price Alert Triggered')
  end
end
