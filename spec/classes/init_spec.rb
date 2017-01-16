require 'spec_helper'
describe 'mongodb_automation_agent' do

  context 'with defaults for all parameters' do
    it { should contain_class('mongodb_automation_agent') }
  end
end
