class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.send_otl.subject
  #
  def send_otl(to_email, otl)
    @register_url = otl
    mail(
      to: to_email,
      subject: "Registrierung bei XPert",
      from: ENV["SMTP_USERNAME"],
      template_path: "user_mailer",
      template_name: "send_otl"
    )
  end
end
