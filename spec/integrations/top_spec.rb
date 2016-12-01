require 'spec_helper'

RSpec.describe 'TopPage' do
  before { visit '/' }

  it 'should display Top Page' do
    expect(page).to have_content('麻雀集計アプリ')
  end
end
