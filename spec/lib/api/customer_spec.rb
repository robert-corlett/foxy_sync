require 'spec_helper'

describe FoxySync::Api::Customer do
  include_examples 'api setup'
  include_examples 'base'
  include_examples 'user'


  let(:subject) { described_class.new user }


  it 'should assign the user' do
    expect(subject.user).to eq user
  end

  it 'should tell the API to save the customer' do
    salt = user.password_salt
    hash = OpenSSL::HMAC.hexdigest 'sha256', salt, user.encrypted_password + salt
    params = {
      :customer_email => user.email,
      :customer_password_hash => hash,
      :customer_password_salt => salt
    }

    FoxySync::Api::Messenger.any_instance.should_receive(:customer_save).with(params)
    subject.save
  end

end