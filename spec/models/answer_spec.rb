require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_inclusion_of(:best).in_array([true, false]) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }
end
