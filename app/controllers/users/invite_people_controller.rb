class Users::InvitePeopleController < ApplicationController
  require "rqrcode"
  before_action :invite
  before_action :generate_qrcode

  def index;
  end

  private

  def invite
      @url = "#{request.base_url}/users/sign_up?promoter=#{current_user.email}"
  end

  def generate_qrcode
    qrcode = RQRCode::QRCode.new("#{@url}")

    @svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true,
      use_path: true
    ).html_safe
  end
end
