RSpec.shared_examples "unauthorized_request" do |method, path|
  it "redirects to the login page" do
    send(method, path)
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(root_path)
  end
end
